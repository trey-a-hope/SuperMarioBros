class Globals {
  Globals._();

  /// Sounds
  static const String bumpSFX = 'smb_bump.wav';
  static const String jumpSmallSFX = 'smb_jump-small.wav';
  static const String pauseSFX = 'smb_pause.wav';
  static const String powerUpAppearsSFX = 'smb_powerup_appears.wav';
  static const String breakBlockSFX = 'smb_breakblock.wav';

  /// Step Times
  static const double marioSpriteStepTime = 0.075;
  static const double goombaSpriteStepTime = 0.4;
  static const double mysteryBlockStepTime = 0.2;
  static const double brickBlockStepTime = 0.2;

  /// Sizes
  static const double tileSize = 16;

  /// Levels
  static const lv_1_1 = 'world_1_1_map.tmx';

  /// Sprite Sheets
  static const String blocksSpriteSheet = 'blocks_spritesheet.png';
  static const String goombaSpriteSheet = 'goomba_spritesheet.png';

  /// Images
  static const String marioIdle = 'mario_idle.gif';
  static const String marioDead = 'mario_dead.gif';
  static const String marioJump = 'mario_jump.gif';
}
