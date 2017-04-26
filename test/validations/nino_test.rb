require 'test_helper'
ActiveValidators.activate(:nino)

describe "NINO validations" do
  describe "for UK" do
    describe "for invalid" do
      it "rejects empty nino" do
        subject = build_nino_record({:nino => ''})
        subject.valid?.must_equal false
      end

      it "rejects nino, which has invalid first letter" do
        invalid_first_letter = %w[d f i q u v]
        invalid_first_letter.each do |letter|
          invalid_nino = letter + 'B123456C'
          subject = build_nino_record({:nino => invalid_nino})
          subject.valid?.must_equal false
        end
      end

      it "rejects nino, which has invalid second letter" do
        invalid_second_letter = %w[d f i q u v o]
        invalid_second_letter.each do |letter|
          invalid_nino = 'a' + letter + '123456C'
          subject = build_nino_record({:nino => invalid_nino})
          subject.valid?.must_equal false
        end
      end

      it "rejects too long nino" do
        subject = build_nino_record({:nino => 'AB123456C100200'})
        subject.valid?.must_equal false
      end

      it "rejects nino with invalid prefix" do
        subject = build_nino_record({:nino => '#$123456C'})
        subject.valid?.must_equal false
      end

      it "rejects nino with invalid chars in number section" do
        subject = build_nino_record({:nino => 'AB@2%4#6C'})
        subject.valid?.must_equal false
      end

      it "rejects wrong suffixes" do
        invalid_suffix = %w[E F G H] # and etc
        invalid_suffix.each do |suffix|
          invalid_nino = 'AB123456' + suffix
          subject = build_nino_record({:nino => invalid_nino})
          subject.valid?.must_equal false
        end
      end

      it "rejects non allocated prefixes" do
        non_allocated_prefixes = %w[bg gb nk kn tn nt zz]
        non_allocated_prefixes.each do |suffix|
          invalid_nino = suffix + '123456C'
          subject = build_nino_record({:nino => invalid_nino})
          subject.valid?.must_equal false
        end
      end

      it "rejects administrative numbers" do
        administrative_numbers = %w[oo cr fy mw nc pp py pz]
        administrative_numbers.each do |suffix|
          invalid_nino = suffix + '123456C'
          subject = build_nino_record({:nino => invalid_nino})
          subject.valid?.must_equal false
        end
      end

      it "rejects temporary numbers" do
        subject = build_nino_record({:nino => '63T12345'})
        subject.valid?.must_equal false
      end
    end

    describe "for valid" do
      it "acepts correct nino" do
        subject = build_nino_record({:nino => 'AB123456C'})
        subject.valid?.must_equal true
      end

      it "acepts nino, divided by spaces" do
        subject = build_nino_record({:nino => 'AB 12 34 56 C'})
        subject.valid?.must_equal true
      end

      it "acepts downcase nino" do
        subject = build_nino_record({:nino => 'ab 12 34 56 c'})
        subject.valid?.must_equal true
      end

      it "acepts correct suffixes" do
        valid_suffix = %w[A B C D]
        valid_suffix.each do |suffix|
          valid_nino = 'AB123456' + suffix
          subject = build_nino_record({:nino => valid_nino})
          subject.valid?.must_equal true
        end
      end
    end
  end

  def build_nino_record(attrs = {})
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :nino, :nino => true
    TestRecord.new attrs
  end
end
