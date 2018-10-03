From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC v2 v2 0/1] ns: introduce binfmt_misc namespace
Date: Wed, 03 Oct 2018 12:13:43 +0200
Message-ID: <1538561623.7448.5.camel@HansenPartnership.com>
References: <20181002102054.13245-1-laurent@vivier.eu>
         <1538496810.14607.5.camel@HansenPartnership.com>
         <a9997ce3-d63d-44b4-6a2a-09fd207a1550@vivier.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a9997ce3-d63d-44b4-6a2a-09fd207a1550@vivier.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Vivier <laurent@vivier.eu>, linux-kernel@vger.kernel.org
Cc: Andrei Vagin <avagin@openvz.org>, Dmitry Safonov <dima@arista.com>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, Eric Biederman <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Tue, 2018-10-02 at 18:47 +0200, Laurent Vivier wrote:
> Le 02/10/2018 à 18:13, James Bottomley a écrit :
> > On Tue, 2018-10-02 at 12:20 +0200, Laurent Vivier wrote:
> > > v2: no new namespace, binfmt_misc data are now part of
> > >     the mount namespace
> > >     I put this in mount namespace instead of user namespace
> > >     because the mount namespace is already needed and
> > >     I don't want to force to have the user namespace for that.
> > >     As this is a filesystem, it seems logic to have it here.
> > > 
> > > This allows to define a new interpreter for each new container.
> > > 
> > > But the main goal is to be able to chroot to a directory
> > > using a binfmt_misc interpreter without being root.
> > 
> > Reading all this, I don't quite understand why this works for me
> > and
> > not for you (I think I get from your explanation that it doesn't
> > work
> > for you, but I might have missed something):
> > 
> > jejb@jarvis:~> uname -m
> > x86_64
> > jejb@jarvis:~> unshare -r -m
> > root@jarvis:~# chroot /home/jejb/containers/aarch64
> > jarvis:/ # uname -m
> > aarch64
> > 
> > Of course to get that to work I have an 'F' entry in
> > /etc/binfmt.d/qemu-aarch64.conf
> > 
> 
> I'd like to configure the interpreter without being root.
> 
> As a simple user can run a VM and a full system inside, I'd like to
> be
> able to start a container/chroot without having to configure
> something
> at the host level.
> 
> For instance, I'd like to provide to "someone" (with no admin rights)
> a tar file with inside an OS environment for a given target and the
> interpreter, and allow him to run the binaries inside just by running
> a simple command (like qemu-system-XXX -hda my.img)

OK, since trying to persuade the distros to add the 'F' flag has been
challenging, I certainly buy this use case.

There is a security risk to allowing an unprivileged user to supply an
arbitrary interpreter (suid and sgid binaries), but as long as
whatever's agreed requires root in the user namespace, I'm happy we
have the security issue confined.

James


> It's also interesting for a test purpose: I can test concurrently
> different interpreters for the same target without modifying the
> target root filesystem (with the 'F' flag but on a per directory
> basis) or the host configuration.
> 
> Another case is we can't configure qemu-mips/qemu-mipsel (old kernel
> API) and qemu-mipsn32/qemu-mipsne32el (new kernel API) interpreters
> on the same system because they share the same ELF signature (to be
> honest qemu should have only one binary for the old and the new
> interface and dynamically change it according to the ELF binary that
> is loaded, as it is done for ARM).
> 
> But if no one thinks it's useful, I don't want to push this more than
> that...
> 
> Thanks,
> Laurent
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
