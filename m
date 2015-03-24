From: Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH 13/14] kdbus: add walk-through user space example
Date: Tue, 24 Mar 2015 19:51:43 +0100
Message-ID: <5511B23F.1020407@zonque.org>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>	<1425906560-13798-14-git-send-email-gregkh@linuxfoundation.org>	<551194C8.4070707@suse.cz> <CANq1E4QmOg0Xjx9d=fDQmuaAO1aBwQAbdwz_7ucyo6LVvFLzUA@mail.gmail.com> <5511A0D6.5030606@suse.cz> <5511AB80.3020102@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090207040409010408060200"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5511AB80.3020102@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Marek <mmarek@suse.cz>, Jiri Slaby <jslaby@suse.cz>, David Herrmann <dh.herrmann@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>, Andy Lutomirski <luto@amacapital.net>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Djalal Harouni <tixxdz@opendz.org>, linux-kbuild@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This is a multi-part message in MIME format.
--------------090207040409010408060200
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 03/24/2015 07:22 PM, Michal Marek wrote:
> Dne 24.3.2015 v 18:37 Jiri Slaby napsal(a):

>> Oh, it's cut&paste, I see. This does not look correct though. The hack
>> inclusive. Host progs are intended to be run on the host where the
>> kernel is built. During the compilation or such (like x/menuconfig).
>> Quite misleading naming if you are used to the autotools one.
> 
> when cross compiling, we are a bit between a rock and a hard place with
> the sample userspace programs:
> - The target toolchain might not have libc support
> - The host toolchain might be lacking recent kernel headers (therefore
>   the need to do make headers_install)
> - It's not clean whether the samples are meant to be ran on the build
>   host or target.

Exactly. I just checked in a cross-compiled source tree, and none of the
compiled standalone executables from samples/ or Documentation/ are
actually built for the target platform. Only the samples which come as
kernel modules are.

> There has been some work by Sam Ravnborg to introduce uapiprogs-y to for
> sample userspace programs, but for now, please use hostprogs-y,
> -Iusr/include and make each sample opt-in.

Alright then. Does the attached patch fix your problem, Jiri?


Thanks,
Daniel


--------------090207040409010408060200
Content-Type: text/x-diff;
 name="0001-kdbus-sample-build-kdbus-workers-conditionally.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-kdbus-sample-build-kdbus-workers-conditionally.patch"

=46rom 56309ab0717720fb086ec3209f1b1fa719072f61 Mon Sep 17 00:00:00 2001
From: Daniel Mack <daniel@zonque.org>
Date: Tue, 24 Mar 2015 19:41:56 +0100
Subject: [PATCH] kdbus: sample: build kdbus-workers conditionally

Give the kdbus sample its own config switch and only build it if it's
explicitly switched on.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 samples/Kconfig        | 7 +++++++
 samples/kdbus/Makefile | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/samples/Kconfig b/samples/Kconfig
index 224ebb4..a4c6b2f 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -55,6 +55,13 @@ config SAMPLE_KDB
 	  Build an example of how to dynamically add the hello
 	  command to the kdb shell.
=20
+config SAMPLE_KDBUS
+	bool "Build kdbus API example"
+	depends on KDBUS
+	help
+	  Build an example of how the kdbus API can be used from
+	  userspace.
+
 config SAMPLE_RPMSG_CLIENT
 	tristate "Build rpmsg client sample -- loadable modules only"
 	depends on RPMSG && m
diff --git a/samples/kdbus/Makefile b/samples/kdbus/Makefile
index d009025..9e40c68 100644
--- a/samples/kdbus/Makefile
+++ b/samples/kdbus/Makefile
@@ -1,7 +1,7 @@
 # kbuild trick to avoid linker error. Can be omitted if a module is buil=
t.
 obj- :=3D dummy.o
=20
-hostprogs-y +=3D kdbus-workers
+hostprogs-$(CONFIG_SAMPLE_KDBUS) +=3D kdbus-workers
=20
 always :=3D $(hostprogs-y)
=20
--=20
2.3.3


--------------090207040409010408060200--
