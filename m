From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH v4 2/2] procfs/tasks: add a simple per-task procfs hidepid=
 field
Date: Mon, 13 Feb 2017 20:11:24 -0800 (PST)
Message-ID: <alpine.DEB.2.20.999.1702132009160.3270@trent.utfs.org>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com> <1484572984-13388-3-git-send-email-djalal@gmail.com> <CAEiveUfDvSoW9Hy2Y_uxU2YQ+vR8OvXMqRhxAANTGG7QaQbJeg@mail.gmail.com> <CALCETrWEGLhEHO_6sTXreVyWFVsEeYmZSrLNNXx-ma5gd+nTQQ@mail.gmail.com>
 <CAEiveUcrSKS9PHAMpiDRChHHK5QDTPh6G63a0p3iXyYP8Wa27w@mail.gmail.com> <CALCETrWn-DpyR5JCGG0H2_yFxU3UHPHZHByXMc5uAxHgQDtnjA@mail.gmail.com> <CAGXu5jKz5vo3NwKb_JmNyWDCP0izK=sxTL6Dx_KmYX=1NK+icA@mail.gmail.com> <CALCETrWNY9Ea=3dKksFJjizoH5eZbVOFWFnWoJrCRwP0R1QWHg@mail.gmail.com>
 <CAGXu5jKJYYkStLM6YhcB_NxfGqx=kVQ-d8QWB2GCBHAksx31MQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jKJYYkStLM6YhcB_NxfGqx=kVQ-d8QWB2GCBHAksx31MQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Djalal Harouni <tixxdz@gmail.com>, Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Lafcadio Wluiki <wluikil@gmail.com>
List-Id: linux-api@vger.kernel.org

On Mon, 13 Feb 2017, Kees Cook wrote:
> Okay, cool. Thanks. (Also, where does "setpriv" live? I must need a
> new set of util-linux or something?)

Indeed, a newer version of util-linux[0] should do, although 
Debian/testing appears to have an extra package just for "setpriv":

  https://packages.debian.org/stretch/setpriv

C.

[0] https://git.kernel.org/cgit/utils/util-linux/util-linux.git/commit/?id=5600c40
-- 
BOFH excuse #65:

system needs to be rebooted
