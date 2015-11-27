From: WEN Pingbo <pingbo.wen@linaro.org>
Subject: [PATCH 0/3] introduce new evdev interface type
Date: Fri, 27 Nov 2015 18:00:29 +0800
Message-ID: <1448618432-32357-1-git-send-email-pingbo.wen@linaro.org>
Return-path: <linux-input-owner@vger.kernel.org>
Sender: linux-input-owner@vger.kernel.org
To: y2038@list.linaro.org, dmitry.torokhov@gmail.com, aksgarg1989@gmail.com, arnd@arndb.de
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, WEN Pingbo <pingbo.wen@linaro.org>
List-Id: linux-api@vger.kernel.org

To solve the y2038 problem in input_event, I had some attempts before [1],
and this is the second one.

We can force userspace to use monotonic time in event timestamp, so the
'struct timeval' is enough to keep y2038-safe, as Arnd suggested. But we
can not find a way to make kernel compatible with old binaries, which use
realtime, and there are still some devices, which depend on realtime.

So I get a idea to add a new evdev interface, which is y2038 safe. And
userspace can switch between the old and new interface via ioctl.

The patch series add three evdev interface type:

- EV_IF_LEGACY
  send event by input_event. This is the default option, keep kernel
  backward compatible.

- EV_IF_RAW
  send event by input_value, which doesn't contain a timestamp. If
  userspace don't need the event timestamp, EV_IF_RAW is the best choice.

- EV_IF_COMPOSITE
  send event by input_composite_event. This is a new structure, which
  append a nanosecond timestamp after input_value. Since the input_value
  and s64 are the same size, so you can treat it as two input_value.

Actually, evdev is not interesting in event timestamp, all it should do is
to keep event sequences, and evdev already satisfy this. So in the kernel,
the event should only store in input_value, input_event and
input_composite_event is used by userspace only.

I also wrote a evtest tool [2], to validate those patches. The tool create
a evdev device via uinput, and inject event through evdev or uinput, with 
different interface type.

I have run this test in my Dragonboard 410c, by this command:

$ evtest -l -r -c -n 400000

No problem found, all events are received normally.

[1]: previous patches - https://www.spinics.net/lists/y2038/msg00959.html
[2]: evtest source code - https://github.com/wengpingbo/evtest

WEN Pingbo (3):
  input: evdev: introduce new evdev interface
  input: evdev: add new ioctl EVIOCSIFTYPE / EVIOCGIFTYPE
  uinput: convert input_event to input_value

 drivers/input/evdev.c        | 117 ++++++++++++++++------------------
 drivers/input/input-compat.c | 148 ++++++++++++++++++++++++++++---------------
 drivers/input/input-compat.h |  48 ++++++++++----
 drivers/input/misc/uinput.c  |  23 ++++---
 include/linux/input.h        |  12 ----
 include/linux/uinput.h       |   2 +-
 include/uapi/linux/input.h   |  27 ++++++++
 7 files changed, 225 insertions(+), 152 deletions(-)

-- 
1.9.1

