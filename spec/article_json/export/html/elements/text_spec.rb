describe ArticleJSON::Export::HTML::Elements::Text do
  subject(:element) { described_class.new(source_element) }

  let(:source_element) do
    ArticleJSON::Elements::Text.new(
      content: 'Foo Bar',
      bold: bold,
      italic: italic,
      href: href
    )
  end
  let(:bold) { false }
  let(:italic) { false }
  let(:href) { nil }

  describe '#build' do
    subject { element.build.to_html }

    context 'when the source element is plain text' do
      it { should eq 'Foo Bar' }
    end

    context 'when the source element is bold text' do
      let(:bold) { true }
      it { should eq '<strong>Foo Bar</strong>' }
    end

    context 'when the source element is italic text' do
      let(:italic) { true }
      it { should eq '<em>Foo Bar</em>' }
    end

    context 'when the source element is italic and bold text' do
      let(:bold) { true }
      let(:italic) { true }
      it { should eq '<strong><em>Foo Bar</em></strong>' }
    end

    context 'when the source element is a link' do
      let(:href) { '/foo/bar' }
      let(:expected_link) { '<a href="/foo/bar">Foo Bar</a>' }

      context 'with plain text' do
        it { should eq expected_link }
      end

      context 'with bold text' do
        let(:bold) { true }
        it { should eq "<strong>#{expected_link}</strong>" }
      end

      context 'with italic text' do
        let(:italic) { true }
        it { should eq "<em>#{expected_link}</em>" }
      end

      context 'with italic and bold text' do
        let(:bold) { true }
        let(:italic) { true }
        it { should eq "<strong><em>#{expected_link}</em></strong>" }
      end
    end
  end
end