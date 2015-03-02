From: Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 0/9] N900 Modem Speech Support
Date: Mon,  2 Mar 2015 05:38:50 +0100
Message-ID: <1425271139-24715-1-git-send-email-sre@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pavel Machek <pavel@ucw.cz>, Pali Rohar <pali.rohar@gmail.com>, Aaro Koskinen <aaro.koskinen@iki.fi>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

This patchset contains the missing speech data support for the
Nokia N900 modem.

Userland access goes via /dev/cmt_speech. The API is implemented in
libcmtspeechdata, which is used by ofono and the freesmartphone.org project.
Apart from that the device is also used by the phone binaries distributed
with Maemo. So while this is a new userland ABI for the mainline kernel it
has been tested in the wild for some years.

Simple Testing of the API can be done by checking out libcmtspeechdata [0],
building the test tool and executing it. The tool will loop back audio data
received from the caller.

I have prepared a kernel branch, which includes these changes at [1].

[0] https://lkml.org/lkml/2015/2/11/526
[1] git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-hsi.git branch/cmt-speech

-- Sebastian

Kai Vehmanen (3):
  HSI: cmt_speech: Add cmt-speech driver
  HSI: cmt_speech: Avoid GFP_ATOMIC in cs_char_open
  HSI: cmt_speech: Return error if HSI port not configured

Sebastian Reichel (6):
  HSI: cmt_speech: Fix build for 4.0 kernel
  HSI: cmt_speech: Cleanup initialisation
  HSI: cmt_speech: Rename driver to cmt-speech
  HSI: cmt_speech: Move cs-protocol.h to include/uapi/linux/hsi
  HSI: cmt_speech: Remove hardcoded channel numbers
  HSI: nokia-modem: Add cmt_speech support

 drivers/hsi/clients/Kconfig          |   11 +-
 drivers/hsi/clients/Makefile         |    1 +
 drivers/hsi/clients/cmt_speech.c     | 1451 ++++++++++++++++++++++++++++++++++
 drivers/hsi/clients/nokia-modem.c    |   31 +-
 include/uapi/linux/hsi/Kbuild        |    2 +-
 include/uapi/linux/hsi/cs-protocol.h |  113 +++
 6 files changed, 1606 insertions(+), 3 deletions(-)
 create mode 100644 drivers/hsi/clients/cmt_speech.c
 create mode 100644 include/uapi/linux/hsi/cs-protocol.h

-- 
2.1.4
