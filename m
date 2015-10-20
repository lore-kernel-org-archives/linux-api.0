From: Tycho Andersen <tycho.andersen@canonical.com>
Subject: v8 of seccomp filter c/r
Date: Tue, 20 Oct 2015 13:50:11 -0600
Message-ID: <1445370612-18843-1-git-send-email-tycho.andersen@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Will Drewry <wad@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Daniel Borkmann <daniel@iogearbox.net>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi all,

Here's v8 of the seccomp filter c/r stuff, which has some minor changes
dropping a lock and changing a constant.

Note that this is now based on http://patchwork.ozlabs.org/patch/525492/ and
will need to be built with that patch applied. This gets rid of two incorrect
patches in a previous series and is a nicer API.

Thoughts welcome,

Tycho
