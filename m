From: Tycho Andersen <tycho.andersen@canonical.com>
Subject: v7 of seccomp filter c/r
Date: Tue, 13 Oct 2015 08:47:05 -0600
Message-ID: <1444747626-8129-1-git-send-email-tycho.andersen@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Will Drewry <wad@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Daniel Borkmann <daniel@iogearbox.net>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi all,

Here's v7 of the seccomp filter c/r stuff. The biggest change is counting down
the seccomp tree instead of up for the index, although there are some other
small changes in the notes as well.

Note that this is now based on http://patchwork.ozlabs.org/patch/525492/ and
will need to be built with that patch applied. This gets rid of two incorrect
patches in a previous series and is a nicer API.

Thoughts welcome,

Tycho
