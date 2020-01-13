From: Ian Kent <raven@themaw.net>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Date: Mon, 13 Jan 2020 14:03:00 +0800
Message-ID: <58f9894e51a00ad2a4ac3d4122bf29e7cb6c0d54.camel@themaw.net>
References: <20191230072959.62kcojxpthhdwmfa@yavin.dot.cyphar.com>
         <20200101004324.GA11269@ZenIV.linux.org.uk>
         <20200101005446.GH4203@ZenIV.linux.org.uk>
         <20200101030815.GA17593@ZenIV.linux.org.uk>
         <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
         <20200101234009.GB8904@ZenIV.linux.org.uk>
         <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
         <20200103014901.GC8904@ZenIV.linux.org.uk>
         <20200110231945.GL8904@ZenIV.linux.org.uk>
         <aea0bc800b6a1e547ca1944738ff9db4379098ba.camel@themaw.net>
         <20200113035407.GQ8904@ZenIV.linux.org.uk>
         <41c535d689530f3715f21cd25074eb61e825a5f6.camel@themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <41c535d689530f3715f21cd25074eb61e825a5f6.camel@themaw.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Aleksa Sarai <cyphar@cyphar.com>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>, Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 2020-01-13 at 14:00 +0800, Ian Kent wrote:
> On Mon, 2020-01-13 at 03:54 +0000, Al Viro wrote:
> > On Mon, Jan 13, 2020 at 09:48:23AM +0800, Ian Kent wrote:
> > 
> > > I did try this patch and I was trying to work out why it didn't
> > > work. But thought I'd let you know what I saw.
> > > 
> > > Applying it to current Linus tree systemd stops at switch root.
> > > 
> > > Not sure what causes that, I couldn't see any reason for it.
> > 
> > Wait a minute...  So you are seeing problems early in the boot,
> > before any autofs ioctls might come into play?
> 
> I did, then I checked it booted without the patch, then tried
> building from scratch with the patch twice and same thing
> happened each time.
> 
> Looked like this, such as it is:
> [ OK ] Reached target Switch Root.
> [ OK ] Started Plymouth switch root service.
>        Starting Switch Root...
> 
> I don't have any evidence but thought it might be this:
> https://github.com/karelzak/util-linux/blob/master/sys-utils/switch_root.c

Oh wait, for systemd I was actually looking at:
https://github.com/systemd/systemd/blob/master/src/shared/switch-root.c

> 
> Mind you, that's not the actual systemd repo. either I probably
> need to look a lot deeper (and at the actual systemd repo) to
> work out what's actually being called.
> 
> > Sigh...  Guess I'll have to dig that Fedora KVM image out and
> > try to see what it's about... ;-/  Here comes a couple of hours
> > of build...
