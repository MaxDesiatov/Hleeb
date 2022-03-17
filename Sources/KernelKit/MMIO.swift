/// Offsets for MMIO registers
struct MMIO {
  fileprivate let rawValue: Builtin.RawPointer
  fileprivate init(_ rawValue: UInt) {
    self.rawValue = Builtin.inttoptr_Word(rawValue)
  }

  #if RPI_2 || RPI_3
  static let mmioBase = MMIO(0x3F00_0000)
  #elseif RPI_4
  static let mmioBase = MMIO(0xFE00_0000)
  #else // Raspberry Pi 1, Zero etc.
  static let mmioBase = MMIO(0x2000_0000)
  #endif

  static let gpioBase = .mmioBase + 0x200000

  /// Control pull up and pull down to all GPIO pins. See this article for more details:
  /// https://www.freecodecamp.org/news/a-simple-explanation-of-pull-down-and-pull-up-resistors-660b308f116a/
  static let gpioPullUpDown = .gpioBase + 0x94

  static let gpioPullUpDownClk0 = .gpioBase + 0x98

  static let uartBase = .gpioBase + 0x1000

  // The offsets for each UART register..
  static let uartDR = .uartBase + 0x00
  static let uartRSRECR = .uartBase + 0x04
  static let uartFR = .uartBase + 0x18
  static let uartILPR = .uartBase + 0x20
  static let uartIBRD = .uartBase + 0x24
  static let uartFBRD = .uartBase + 0x28
  static let uartLCRH = .uartBase + 0x2C
  static let uartCR = .uartBase + 0x30
  static let uartIFLS = .uartBase + 0x34
  static let uartIMSC = .uartBase + 0x38
  static let uartRIS = .uartBase + 0x3C
  static let uartMIS = .uartBase + 0x40
  static let uartICR = .uartBase + 0x44
  static let uartDMACR = .uartBase + 0x48
  static let uartITCR = .uartBase + 0x80
  static let uartITIP = .uartBase + 0x84
  static let uartITOP = .uartBase + 0x88
  static let uartTDR = .uartBase + 0x8C

  // The offsets for Mailbox registers
  static let mboxBase = .mmioBase + 0xB880
  static let mboxRead = .mboxBase + 0x00
  static let mboxStatus = .mboxBase + 0x18
  static let mboxWrite = .mboxBase + 0x20

  @inline(__always)
  func write(data: UInt32) {
    UnsafeMutableRawPointer(bitPattern: rawValue)?.storeBytes(of: data, as: UInt32.self)
  }
}

private func + (rhs: MMIO, lhs: UInt) -> MMIO {
  MMIO(Builtin.gepRaw_Word(rhs.rawValue, lhs))
}
