require 'spec_helper'

describe Spoon::Parser do
  let(:parser) { Spoon::Parser.new }

  context "binary operation" do
    subject { parser.binary_operation }

    it { should parse "foo + bar" }
    it { should parse "foo * bar" }
    it { should_not parse "foo + bar + baz" }
  end

  context "block" do
    subject { parser.block }

    it { should parse "\n print foo\n return bar\n" }
    it { should_not parse "\n print foo\n return bar" }
  end

  context "call" do
    subject { parser.call }

    it { should parse "foo bar" }
    it { should parse "foo(bar)" }
    it { should parse "foo bar, baz" }
    it { should parse "foo(bar, baz)" }
  end

  context "chain" do
    subject { parser.chain }

    it { should parse "foo.bar" }
    it { should parse "foo().bar().baz(foo, bar).baz" }
  end

  context "closure" do
    subject { parser.closure }

    it { should parse "-> foo" }
    it { should parse "() -> foo" }
    it { should parse "foo -> bar" }
    it { should parse "foo, bar -> baz" }
    it { should parse "(foo, bar) -> baz" }
  end

  context "comment" do
    subject { parser.comment }

    it { should parse "# foo" }
    it { should parse "#foo" }
    it { should_not parse "# foo\n bar" }
  end

  context "condition" do
    subject { parser.condition }

    it { should parse "if (foo) bar" }
    it { should parse "if foo then bar" }
    it { should parse "if (foo) bar else if (baz) foo else bar" }
    it { should_not parse "if foo bar" }
  end

  context "expression" do
    subject { parser.expression }

    it { should parse "foo and bar" }
    it { should parse "foo * bar" }
    it { should_not parse "foo ** bar" }
  end

  context "function" do
    subject { parser.function }

    it { should parse "function foo bar" }
    it { should parse "function foo() bar" }
    it { should parse "function foo bar = 1 baz" }
    it { should parse "function foo(bar = 1) baz" }
  end

  context "name" do
    subject { parser.name }

    it { should parse "foo" }
    it { should parse "Foo" }
    it { should parse "foo-bar" }
    it { should_not parse "-foo" }
    it { should_not parse "foo2" }
    it { should_not parse "foo?" }
    it { should_not parse "foo_bar" }
  end

  context "number" do
    subject { parser.number }

    it { should parse "10" }
    it { should parse "+0" }
    it { should parse "-10" }
    it { should parse "1.0" }
    it { should parse "0.0" }
    it { should parse "-10.0" }
    it { should parse "1e10" }
    it { should_not parse "a2" }
  end

  context "root" do
    subject { parser.root }

    it { should parse "# foo\n    print bar\n # baz " }
  end

  context "unary operation" do
    subject { parser.unary_operation }

    it { should parse "++foo" }
    it { should parse "foo++" }
    it { should parse "not foo" }
    it { should_not parse "foo + bar" }
  end
end
