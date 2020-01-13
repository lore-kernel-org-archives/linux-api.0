From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Date: Mon, 13 Jan 2020 03:54:07 +0000
Message-ID: <20200113035407.GQ8904@ZenIV.linux.org.uk>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <aea0bc800b6a1e547ca1944738ff9db4379098ba.camel@themaw.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ian Kent <raven@themaw.net>
Cc: Aleksa Sarai <cyphar@cyphar.com>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>, Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 13, 2020 at 09:48:23AM +0800, Ian Kent wrote:

> I did try this patch and I was trying to work out why it didn't
> work. But thought I'd let you know what I saw.
> 
> Applying it to current Linus tree systemd stops at switch root.
> 
> Not sure what causes that, I couldn't see any reason for it.

Wait a minute...  So you are seeing problems early in the boot,
before any autofs ioctls might come into play?

Sigh...  Guess I'll have to dig that Fedora KVM image out and
try to see what it's about... ;-/  Here comes a couple of hours
of build...
