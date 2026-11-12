class AlphabetLetter {
  const AlphabetLetter({
    required this.character,
    required this.pronunciationBn,
    required this.spokenName,
  });

  final String character;
  final String pronunciationBn;
  final String spokenName;
}

/// German alphabet: A-Z plus Ä, Ö, Ü and ß.
const List<AlphabetLetter> germanAlphabet = [
  AlphabetLetter(character: 'A', pronunciationBn: 'আ', spokenName: 'A'),
  AlphabetLetter(character: 'B', pronunciationBn: 'বে', spokenName: 'Be'),
  AlphabetLetter(character: 'C', pronunciationBn: 'ৎসে', spokenName: 'Ce'),
  AlphabetLetter(character: 'D', pronunciationBn: 'ডে', spokenName: 'De'),
  AlphabetLetter(character: 'E', pronunciationBn: 'এ', spokenName: 'E'),
  AlphabetLetter(character: 'F', pronunciationBn: 'এফ', spokenName: 'Ef'),
  AlphabetLetter(character: 'G', pronunciationBn: 'গে', spokenName: 'Ge'),
  AlphabetLetter(character: 'H', pronunciationBn: 'হা', spokenName: 'Ha'),
  AlphabetLetter(character: 'I', pronunciationBn: 'ই', spokenName: 'I'),
  AlphabetLetter(character: 'J', pronunciationBn: 'ইয়ট', spokenName: 'Jot'),
  AlphabetLetter(character: 'K', pronunciationBn: 'কা', spokenName: 'Ka'),
  AlphabetLetter(character: 'L', pronunciationBn: 'এল', spokenName: 'El'),
  AlphabetLetter(character: 'M', pronunciationBn: 'এম', spokenName: 'Em'),
  AlphabetLetter(character: 'N', pronunciationBn: 'এন', spokenName: 'En'),
  AlphabetLetter(character: 'O', pronunciationBn: 'ও', spokenName: 'O'),
  AlphabetLetter(character: 'P', pronunciationBn: 'পে', spokenName: 'Pe'),
  AlphabetLetter(character: 'Q', pronunciationBn: 'কু', spokenName: 'Qu'),
  AlphabetLetter(character: 'R', pronunciationBn: 'এর', spokenName: 'Er'),
  AlphabetLetter(character: 'S', pronunciationBn: 'এস', spokenName: 'Es'),
  AlphabetLetter(character: 'T', pronunciationBn: 'টে', spokenName: 'Te'),
  AlphabetLetter(character: 'U', pronunciationBn: 'উ', spokenName: 'U'),
  AlphabetLetter(character: 'V', pronunciationBn: 'ফাউ', spokenName: 'Vau'),
  AlphabetLetter(character: 'W', pronunciationBn: 'ভে', spokenName: 'We'),
  AlphabetLetter(character: 'X', pronunciationBn: 'ইক্স', spokenName: 'Ix'),
  AlphabetLetter(character: 'Y', pronunciationBn: 'ইপ্সিলন', spokenName: 'Ypsilon'),
  AlphabetLetter(character: 'Z', pronunciationBn: 'ৎসেট', spokenName: 'Zett'),
  AlphabetLetter(character: 'Ä', pronunciationBn: 'এ (অ্যা-ধ্বনি)', spokenName: 'Ä'),
  AlphabetLetter(character: 'Ö', pronunciationBn: 'ও-এ মাঝামাঝি (ö)', spokenName: 'Ö'),
  AlphabetLetter(character: 'Ü', pronunciationBn: 'উ-ই মাঝামাঝি (ü)', spokenName: 'Ü'),
  AlphabetLetter(character: 'ß', pronunciationBn: 'এস-ৎসেট', spokenName: 'Eszett'),
];
