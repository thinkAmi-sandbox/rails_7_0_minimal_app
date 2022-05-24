class WrapParameter::OutputsController < ApplicationController
  # POSTする時にCSRFで引っかかってしまうので、今回は外しておく
  protect_from_forgery except: :create

  def create
    output_params

    head :created
  end

  private def output_params
    # すべて
    write_log(params)
    # => {"name"=>"foo", "age"=>20, "controller"=>"wrap_parameter/outputs", "action"=>"create", "output"=>{"name"=>"foo", "age"=>20}}

    # キーを指定
    write_log(params[:name])
    # => foo

    # wrap parametersのキーを指定
    write_log(params[:output])
    # => {"name"=>"foo", "age"=>20}


    logger.info("========= no require ============")

    # requireなし
    write_log(params.permit(:name, :age))
    # => {"name"=>"foo", "age"=>20}

    ## 配列
    write_log(params.permit(pages: []))
    # => {"pages"=>[1, 2, 3]}

    ## ネストしたオブジェクト
    write_log(params.permit(article: [:title, :content]))
    # => {"article"=>#<ActionController::Parameters {"title"=>"hello"} permitted: true>}

    ## 複雑なネスト
    write_log(params.permit(:name, :age, article: [:title, :content, authors: [:name, pages: []]]))
    # => {"name"=>"foo",
    #     "age"=>20,
    #     "article"=>#<ActionController::Parameters {
    #       "title"=>"hello",
    #       "authors"=>[
    #         #<ActionController::Parameters {"name"=>"bob", "pages"=>[1, 3]} permitted: true>,
    #         #<ActionController::Parameters {"name"=>"alice", "pages"=>[2, 4]} permitted: true>
    #       ]
    #     } permitted: true>
    #    }

    logger.info("========= with require ============")

    # require使う
    write_log(params.require(:output).permit(:name, :age))
    # => {"name"=>"foo", "age"=>20}

    ## 配列
    write_log(params.require(:output).permit(pages: []))
    # => {"pages"=>[1, 2, 3]}

    ## ネストしたオブジェクト
    write_log(params.require(:output).permit(article: [:title, :content]))
    # => {"article"=>#<ActionController::Parameters {"title"=>"hello"} permitted: true>}

    ## 複雑なネスト
    write_log(params.require(:output).permit(:name, :age, article: [:title, :content, authors: [:name, pages: []]]))
    # => {"name"=>"foo",
    #     "age"=>20,
    #     "article"=>#<ActionController::Parameters {
    #       "title"=>"hello",
    #       "authors"=>[
    #         #<ActionController::Parameters {"name"=>"bob", "pages"=>[1, 3]} permitted: true>,
    #         #<ActionController::Parameters {"name"=>"alice", "pages"=>[2, 4]} permitted: true>
    #       ]
    #     } permitted: true>
    #    }

  end

  private def write_log(values)
    logger.info('============>')
    logger.info(values)
    logger.info('<============')
  end
end