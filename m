From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Date: Mon, 13 Jan 2020 13:30:47 +0000
Message-ID: <20200113133047.GR8904@ZenIV.linux.org.uk>
References: <20200101030815.GA17593@ZenIV.linux.org.uk>
 <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
 <20200101234009.GB8904@ZenIV.linux.org.uk>
 <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
 <20200103014901.GC8904@ZenIV.linux.org.uk>
 <20200110231945.GL8904@ZenIV.linux.org.uk>
 <aea0bc800b6a1e547ca1944738ff9db4379098ba.camel@themaw.net>
 <20200113035407.GQ8904@ZenIV.linux.org.uk>
 <41c535d689530f3715f21cd25074eb61e825a5f6.camel@themaw.net>
 <58f9894e51a00ad2a4ac3d4122bf29e7cb6c0d54.camel@themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <58f9894e51a00ad2a4ac3d4122bf29e7cb6c0d54.camel@themaw.net>
Sender: stable-owner@vger.kernel.org
To: Ian Kent <raven@themaw.net>
Cc: Aleksa Sarai <cyphar@cyphar.com>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>, Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 13, 2020 at 02:03:00PM +0800, Ian Kent wrote:

> Oh wait, for systemd I was actually looking at:
> https://github.com/systemd/systemd/blob/master/src/shared/switch-root.c
> 
> > 
> > Mind you, that's not the actual systemd repo. either I probably
> > need to look a lot deeper (and at the actual systemd repo) to
> > work out what's actually being called.
> > 
> > > Sigh...  Guess I'll have to dig that Fedora KVM image out and
> > > try to see what it's about... ;-/  Here comes a couple of hours
> > > of build...

D'oh...  And yes, that would've been a bisect hazard - switch to
path_lookupat() later in the series gets rid of that.  Incremental
(to be foldede, of course):

diff --git a/fs/namei.c b/fs/namei.c
index 1793661c3342..204677c37751 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2634,7 +2634,7 @@ path_mountpoint(struct nameidata *nd, unsigned flags, struct path *path)
 		(err = lookup_last(nd)) > 0) {
 		s = trailing_symlink(nd);
 	}
-	if (!err)
+	if (!err && (nd->flags & LOOKUP_RCU))
 		err = unlazy_walk(nd);
 	if (!err)
 		err = handle_lookup_down(nd);
