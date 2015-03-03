From: Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv2 0/2] N900 Modem Speech Support
Date: Tue,  3 Mar 2015 01:44:12 +0100
Message-ID: <1425343454-6551-1-git-send-email-sre@kernel.org>
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

I have prepared a kernel branch for this patchset, which can be found at [1].

Changes since PATCHv1 [2]:
 * Squash cmt-speech patches together
 * cs_alloc_cmds(): GFP_ATOMIC -> GFP_KERNEL
 * CS_SET_WAKELINE ioctl: Add sanity check

[0] https://lkml.org/lkml/2015/2/11/526
[1] git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-hsi.git branch/cmt-speech-2
[2] https://lkml.org/lkml/2015/3/1/282

-- Sebastian

Kai Vehmanen (1):
  HSI: cmt_speech: Add cmt-speech driver

Sebastian Reichel (1):
  HSI: nokia-modem: Add cmt-speech support

 drivers/hsi/clients/Kconfig          |   11 +-
 drivers/hsi/clients/Makefile         |    1 +
 drivers/hsi/clients/cmt_speech.c     | 1457 ++++++++++++++++++++++++++++++++++
 drivers/hsi/clients/nokia-modem.c    |   31 +-
 include/uapi/linux/hsi/Kbuild        |    2 +-
 include/uapi/linux/hsi/cs-protocol.h |  113 +++
 6 files changed, 1612 insertions(+), 3 deletions(-)
 create mode 100644 drivers/hsi/clients/cmt_speech.c
 create mode 100644 include/uapi/linux/hsi/cs-protocol.h

-- 
2.1.4
