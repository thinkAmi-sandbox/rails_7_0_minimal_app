# == Schema Information
#
# Table name: authors
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'style' do
    context 'method' do
      context 'symbol' do
        context 'model' do
          it 'pass' do
            expect { Author.create!(name: 'thinkAmi') }.to change(Author, :count)
          end
        end

        context 'instance' do
          let!(:author) { create(:author, name: 'thinkAmi') }

          it 'pass' do
            expect { author.update!(name: 'Foo') }.to change(author.reload, :name)
          end
        end
      end

      pending 'attribute' do
        it 'pass' do
          # ArgumentError: `change` requires either an object and message (`change(obj, :msg)`) or a block (`change { }`).
          # You passed an object but no message.
          expect { Author.create!(name: 'thinkAmi') }.to change(Author.count)
        end
      end
    end

    context 'block' do
      context 'attribute' do
        it 'pass' do
          expect { Author.create!(name: 'thinkAmi') }.to change { Author.count }
        end
      end

      context 'dot access' do
        it 'pass' do
          author = create(:author, name: 'thinkAmi')
          expect { Blog.create!(name: 'my blog', author: author) }.to change { author.blogs.count }
        end
      end
    end
  end

  describe 'by, from, to' do
    context 'by' do
      it 'pass' do
        expect { Author.create!(name: 'thinkAmi') }.to change(Author, :count).by(1)
      end
    end

    context 'from to' do
      it 'pass' do
        expect { Author.create!(name: 'thinkAmi') }.to change(Author, :count).from(0).to(1)
      end
    end
  end

  describe 'by_at_least' do
    it 'pass' do
      100.times do
        expect { Author.random_create }.to change(Author, :count).by_at_least(1)
      end
    end
  end

  describe 'by_at_most' do
    it 'pass' do
      100.times do
        expect { Author.random_create }.to change(Author, :count).by_at_most(2)
      end
    end
  end

  describe 'not change' do
    context 'not_to' do
      it 'pass' do
        author = Author.create(name: 'thinkAmi')
        expect { author.update!(name: author.name) }.not_to change(Author, :count)
      end
    end

    context 'to_not' do
      it 'pass' do
        author = Author.create(name: 'thinkAmi')
        expect { author.update!(name: author.name) }.to_not change(Author, :count)
      end
    end
  end

  describe 'and' do
    context 'change and change' do
      it 'pass' do
        expect {
          author = Author.create!(name: 'thinkAmi')
          Blog.create!(name: 'My blog', author: author)
        }.to change(Author, :count).by(1).and change(Blog, :count).by(1)
      end
    end

    context 'change and not change' do
      pending 'without define_negated_matcher' do
        it 'NotImplementedError' do
          author = Author.create!(name: 'thinkAmi')

          # `expect(...).not_to matcher.and matcher` is not supported, since it creates a bit of an ambiguity.
          # Instead, define negated versions of whatever matchers you wish to negate
          # with `RSpec::Matchers.define_negated_matcher` and use `expect(...).to matcher.and matcher`.
          expect { Blog.create!(name: 'My blog', author: author) }.not_to change(Author, :count).and change(Blog, :count).by(1)
        end
      end

      context 'with define_negated_matcher' do
        RSpec::Matchers.define_negated_matcher :not_change, :change

        context 'to not_change' do
          it 'pass' do
            author = Author.create!(name: 'thinkAmi')
            expect { Blog.create!(name: 'My blog', author: author) }.to not_change(Author, :count).and change(Blog, :count).by(1)
          end
        end
      end
    end
  end

  describe 'reload' do
    context 'instance' do
      around(:example) do |example|
        ActiveRecord::Base.logger = Logger.new(STDOUT)
        example.run
        ActiveRecord::Base.logger = nil
      end

      context 'without reload' do
        it 'pass' do
          author = Author.create!(name: 'thinkAmi')
          expect { Author.find(author.id).update!(name: 'Foo') }.not_to change(author, :name)
        end
      end

      context 'with reload' do
        it 'pass' do
          author = Author.create!(name: 'thinkAmi')
          expect { Author.find(author.id).update!(name: 'Foo') }.to change { author.reload.name }.to('Foo')
        end
      end

      context 'with single reload' do
        it 'pass' do
          author = Author.create!(name: 'thinkAmi')
          expect { Author.find(author.id).update!(name: 'Foo'); author.reload }.to change { author.name }.to('Foo')
        end
      end
    end

    context 'attr_accessor' do
      RSpec::Matchers.define_negated_matcher :not_change, :change

      it 'pass' do
        author = Author.create!(name: 'thinkAmi')
        author.age = 20

        expect {
          Author.find(author.id) do |a|
            a.name = 'Foo'
            a.age = 10
            a.save!
          end

          author.reload
        }.to change { author.name }.to('Foo').and not_change { author.age }.from(20)
      end
    end

    context 'reload_association' do
      it 'pass' do
        author = Author.create!(name: 'thinkAmi')
        blog = Blog.create!(name: 'Foo', published: true, author: author)

        expect {
          Author.find(author.id).update!(name: 'Bar')
          Blog.find(blog.id).update!(name: 'Baz')

          blog.reload_author
        }.to change { blog.author.name }.to('Bar').and not_change { blog.name }
      end
    end

    context 'multiple attributes' do
      context 'change chain' do
        it 'pass' do
          author = Author.create!(name: 'thinkAmi')
          blog = Blog.create!(name: 'Foo', published: true, author: author)
          expect {
            Blog.find(blog.id).update!(name: 'Bar', published: false)
            blog.reload
          }.to change { blog.name }.to('Bar').and change { blog.published }.to(false)
        end
      end

      context 'have_attributes' do
        pending 'raise error as of 3.12.0' do
          # https://github.com/rspec/rspec-expectations/issues/1131
          it 'error' do
            author = Author.create!(name: 'thinkAmi')
            blog = Blog.create!(name: 'Foo', published: true, author: author)

            # expected `blog` to have changed to
            # #<RSpec::Matchers::BuiltIn::HaveAttributes:0x00007fe17dc15028 @actual=nil, @expected={
            # name: "Bar", published: false }, @negated=false, @respond_to_failed=false, @values={}>,
            # but did not change
            expect {
              Blog.find(blog.id).update!(name: 'Bar', published: false)
              blog.reload
            }.to change { blog }.to have_attributes(name: 'Bar', published: false)
          end
        end

        context 'pass as of 3.12.0' do
          # https://github.com/rspec/rspec-expectations/issues/1131
          # https://github.com/benoittgt/testing_6_0_0_rc1/blob/bump-to-last-6/spec/requests/widgets_request_spec.rb#L31

          context 'attributes.with_indifferent_access' do
            it 'pass' do
              author = Author.create!(name: 'thinkAmi')
              blog = Blog.create!(name: 'Foo', published: true, author: author)

              expect {
                Blog.find(blog.id).update!(name: 'Bar', published: false)
                blog.reload
              }.to change { blog.attributes.with_indifferent_access }.to a_hash_including(name: 'Bar', published: false)
            end
          end

          context 'dup' do
            it 'pass' do
              author = Author.create!(name: 'thinkAmi')
              blog = Blog.create!(name: 'Foo', published: true, author: author)

              expect {
                Blog.find(blog.id).update!(name: 'Bar', published: false)
                blog.reload
              }.to change { blog.dup }.to have_attributes(name: 'Bar', published: false)
            end
          end
        end
      end
    end
  end

  describe 'subject' do
    subject do
      author = Author.create!(name: 'thinkAmi')
      Blog.create!(name: 'Foo', published: true, author: author)
    end

    pending 'bad' do
      it 'fail' do
        expect { subject }.to change(Author, :count)
        expect { subject }.to change(Blog, :count)
      end
    end

    context 'good' do
      it 'pass' do
        expect { subject }.to change(Author, :count).and change(Blog, :count)
      end
    end
  end

  describe 'exception' do
    let!(:author) { create(:author, name: 'thinkAmi') }
    pending 'bad' do
      it 'fail' do
        expect {
          author.update_name_with_calling_api!('Foo')
          author.reload
        }.to change { author.name }.to('Foo')
      end
    end

    context 'good' do
      context '2 args' do
        it 'pass' do
          expect {
            author.update_name_with_calling_api!('Foo')
            author.reload
          }.to raise_error(StandardError, 'bad api').and change { author.name }.to('Foo')
        end
      end

      context 'with_message' do
        it 'pass' do
          expect {
            author.update_name_with_calling_api!('Foo'); author.reload
          }.to raise_error(StandardError).with_message('bad api').and change { author.name }.to('Foo')
        end
      end

      context 'with_message regex' do
        it 'pass' do
          expect {
            author.update_name_with_calling_api!('Foo'); author.reload
          }.to raise_error(StandardError).with_message(/ad a/).and change { author.name }.to('Foo')
        end
      end
    end
  end
end
