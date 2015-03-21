From: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHv3 0/2] N900 Modem Speech Support
Date: Sat, 21 Mar 2015 20:09:15 +0100
Message-ID: <1426964957-5023-1-git-send-email-sre@kernel.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>, Kai Vehmanen <kvcontact-nQfqiRJ1PMYxHbG02/KK1g@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Pali Rohar <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aaro Koskinen <aaro.koskinen-X3B1VOXEql0@public.gmane.org>, Ivaylo Dimitrov <ivo.g.dimitrov.75-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
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

Changes since PATCHv2 [3]:
 * Change MODULE_LICENSE from "GPL" to "GPL v2"
 * Add some cleanups suggested by Pavel
 * Add missing dependency on SSI_PROTOCOL in Kconfig

Changes since PATCHv1 [2]:
 * Squash cmt-speech patches together
 * cs_alloc_cmds(): GFP_ATOMIC -> GFP_KERNEL
 * CS_SET_WAKELINE ioctl: Add sanity check

[0] https://lkml.org/lkml/2015/2/11/526
[1] git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-hsi.git branch/cmt-speech-2
[2] https://lkml.org/lkml/2015/3/1/282
[3] https://lkml.org/lkml/2015/3/4/1139

-- Sebastian

Kai Vehmanen (1):
  HSI: cmt_speech: Add cmt-speech driver

Sebastian Reichel (1):
  HSI: nokia-modem: Add cmt-speech support

 drivers/hsi/clients/Kconfig          |   12 +-
 drivers/hsi/clients/Makefile         |    1 +
 drivers/hsi/clients/cmt_speech.c     | 1456 ++++++++++++++++++++++++++++++++++
 drivers/hsi/clients/nokia-modem.c    |   32 +-
 include/uapi/linux/hsi/Kbuild        |    2 +-
 include/uapi/linux/hsi/cs-protocol.h |  113 +++
 6 files changed, 1613 insertions(+), 3 deletions(-)
 create mode 100644 drivers/hsi/clients/cmt_speech.c
 create mode 100644 include/uapi/linux/hsi/cs-protocol.h

-- 
2.1.4
