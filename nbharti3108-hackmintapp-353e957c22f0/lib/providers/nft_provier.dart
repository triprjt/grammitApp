class NftProfile {
  final String? userId;
  final String? userName;
  final String? avatarUrl;
  final Map<String, dynamic>? characteristics;

  NftProfile(
      {this.userId, this.userName, this.avatarUrl, this.characteristics});

  static NftProfile generateProfile() {
    return NftProfile(
        userId: '1002',
        userName: 'Nishant',
        avatarUrl: 'lib/icons/avatar.png',
        characteristics: {
          'Time': 'Lorem Ipsum',
          'Speed': 'Lorem Ipsum',
          'Accuracy': 'Lorem Ipsum',
          'Some other': 'Lorem Ipsum'
        });
  }
}
