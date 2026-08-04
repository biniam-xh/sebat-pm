/// Lightweight channel reference for PM ↔ Chat links.
class ChannelRef {
  const ChannelRef({
    required this.channelId,
    required this.name,
  });

  final String channelId;
  final String name;
}
