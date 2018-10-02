From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC v2 v2 0/1] ns: introduce binfmt_misc namespace
Date: Tue, 02 Oct 2018 18:13:30 +0200
Message-ID: <1538496810.14607.5.camel@HansenPartnership.com>
References: <20181002102054.13245-1-laurent@vivier.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181002102054.13245-1-laurent@vivier.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Vivier <laurent@vivier.eu>, linux-kernel@vger.kernel.org
Cc: Andrei Vagin <avagin@openvz.org>, Dmitry Safonov <dima@arista.com>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, Eric Biederman <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Tue, 2018-10-02 at 12:20 +0200, Laurent Vivier wrote:
> v2: no new namespace, binfmt_misc data are now part of
>     the mount namespace
>     I put this in mount namespace instead of user namespace
>     because the mount namespace is already needed and
>     I don't want to force to have the user namespace for that.
>     As this is a filesystem, it seems logic to have it here.
> 
> This allows to define a new interpreter for each new container.
> 
> But the main goal is to be able to chroot to a directory
> using a binfmt_misc interpreter without being root.

Reading all this, I don't quite understand why this works for me and
not for you (I think I get from your explanation that it doesn't work
for you, but I might have missed something):

jejb@jarvis:~> uname -m
x86_64
jejb@jarvis:~> unshare -r -m
root@jarvis:~# chroot /home/jejb/containers/aarch64
jarvis:/ # uname -m
aarch64

Of course to get that to work I have an 'F' entry in
/etc/binfmt.d/qemu-aarch64.conf

Which means I'm running the host emulator in the container, which is
what I want to do.  I think another goal of the patches might be to use
different emulators for different aarch64 containers?  Do you have a
use case for this, because right at the moment for arch emulation
containers I think a single host wide entry per static emulator is the
right approach.

James
