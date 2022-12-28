///Stores information about the a start and end location that has been claimed
///
///[ClaimedRegion]'s information can then be used to help detect overlaps
class ClaimedRegion {
  final double start;
  final double end;
  ClaimedRegion(this.start, this.end);

  ///overlap is true if [other] overlaps with this claimed region, else false
  ///
  ///[other] is considered to overlap with this claimed region if the start of
  ///[other] is between the start and end of this claimed region, or if the end
  ///of [other] is between the start and end of this claimed region
  bool overlap(ClaimedRegion other) {
    return (other.start >= start && other.start <= end) ||
        (other.end >= start && other.end <= end);
  }
}
