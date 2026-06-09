class Donation {
  final int? id;
  final String donorName;
  final int amount;
  final String paymentMethod;
  final String note;
  final String proofImage;
  final String status;
  final String createdAt;

  Donation({
    this.id,
    required this.donorName,
    required this.amount,
    required this.paymentMethod,
    this.note = '',
    this.proofImage = '',
    this.status = 'Menunggu',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'donor_name': donorName,
      'amount': amount,
      'payment_method': paymentMethod,
      'note': note,
      'proof_image': proofImage,
      'status': status,
      'created_at': createdAt,
    };
  }

  factory Donation.fromMap(Map<String, dynamic> map) {
    return Donation(
      id: map['id'],
      donorName: map['donor_name'] ?? '',
      amount: map['amount'] ?? 0,
      paymentMethod: map['payment_method'] ?? '',
      note: map['note'] ?? '',
      proofImage: map['proof_image'] ?? '',
      status: map['status'] ?? 'Menunggu',
      createdAt: map['created_at'] ?? '',
    );
  }

  Donation copyWith({
    int? id,
    String? donorName,
    int? amount,
    String? paymentMethod,
    String? note,
    String? proofImage,
    String? status,
    String? createdAt,
  }) {
    return Donation(
      id: id ?? this.id,
      donorName: donorName ?? this.donorName,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      note: note ?? this.note,
      proofImage: proofImage ?? this.proofImage,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
