From: Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Date: Tue, 14 Jan 2020 15:25:15 +0800
Message-ID: <7b2b9f81871898d2b6301a74f2bee85943f21cdc.camel@themaw.net>
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
         <20200113133047.GR8904@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200113133047.GR8904-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2020-01-13 at 13:30 +0000, Al Viro wrote:
> On Mon, Jan 13, 2020 at 02:03:00PM +0800, Ian Kent wrote:
> 
> > Oh wait, for systemd I was actually looking at:
> > https://github.com/systemd/systemd/blob/master/src/shared/switch-root.c
> > 
> > > Mind you, that's not the actual systemd repo. either I probably
> > > need to look a lot deeper (and at the actual systemd repo) to
> > > work out what's actually being called.
> > > 
> > > > Sigh...  Guess I'll have to dig that Fedora KVM image out and
> > > > try to see what it's about... ;-/  Here comes a couple of hours
> > > > of build...
> 
> D'oh...  And yes, that would've been a bisect hazard - switch to
> path_lookupat() later in the series gets rid of that.  Incremental
> (to be foldede, of course):
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 1793661c3342..204677c37751 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2634,7 +2634,7 @@ path_mountpoint(struct nameidata *nd, unsigned
> flags, struct path *path)
>  		(err = lookup_last(nd)) > 0) {
>  		s = trailing_symlink(nd);
>  	}
> -	if (!err)
> +	if (!err && (nd->flags & LOOKUP_RCU))
>  		err = unlazy_walk(nd);
>  	if (!err)
>  		err = handle_lookup_down(nd);

Ok, so I've tested with the updated patch.

The autofs connectathon tests I use function fine.

I also tested sending a SIGKILL to the daemon with about 180 active
mounts and restarted the daemon to test the function of the ioctls
that Al was concerned about.

While the connectathon test expired everything I had 3 mounts left
after allowing sufficient expire time with the SIGKILL test.

Those mounts correspond to one map entry that has a mix of NFS
vers=3 and vers=2 mount options and NFSv2 isn't supported by the
servers I use in testing.

I'm inclined to think this is a bug in the automount mount tree
re-connection code rather than a problem with this patch since
all the other mounts, some simple and others with not so simple
constructs, expired fine after automount re-connected to them.

There are two other map entries that have an NFS vers=2 option but
they are simple mounts that will fail on attempting the automount
because the server doesn't support v2 so they don't end up with
mounts to reconnect to.

This particular map entry, having a mix of NFS vers=3 and vers=2
in the offsets of the entry, will lead to a partial mount of the
map entry which is probably not being handled properly by automount
when re-connecting to the mounts in the tree.

So I think the patch here is fine from an autofs POV.

Ian
