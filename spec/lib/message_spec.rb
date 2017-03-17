require_relative '../../lib/message'

describe Message do
  include Message

  context 'Prefixing Namespaces' do
    it 'takes a filename and creates the equivalent namespace sexp' do
      expect(prefix_namespace('src/watermarker/core.clj', 'x')).to eq(
        "(ns watermarker.core)\n\nx"
      )
    end

    it 'removes clj(s|c) from paths with clj after src' do
      expect(prefix_namespace('src/clj/watermarker/core.clj', 'x')).to eq(
        "(ns watermarker.core)\n\nx"
      )
      expect(prefix_namespace('src/cljs/watermarker/core.clj', 'x')).to eq(
        "(ns watermarker.core)\n\nx"
      )
      expect(prefix_namespace('src/cljc/watermarker/core.clj', 'x')).to eq(
        "(ns watermarker.core)\n\nx"
      )
      expect(prefix_namespace('src/cljx/watermarker/core.clj', 'x')).to eq(
        "(ns watermarker.core)\n\nx"
      )
    end

    it 'converts _ to - in the namespace' do
      expect(
        prefix_namespace('test/clj/water_marker/core_test.clj', 'x')
      ).to eq(
        "(ns water-marker.core-test)\n\nx"
      )
    end

    it 'works for where a filepath has src or test' do
      expect(prefix_namespace('test/clj/watermarker/atest.clj', 'x')).to eq(
        "(ns watermarker.atest)\n\nx"
      )
    end

    it 'avoids prefixing a namespace altogether if src/test are not found on the filepath' do
      expect(prefix_namespace('scratchfile.clj', 'x')).to eq(
        "x"
      )
    end
  end
end
# 'src/clj/sbsl/price_services/schema/deals.clj'
