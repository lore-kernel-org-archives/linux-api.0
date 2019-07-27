From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Regression in 5.3 for some FS_USERNS_MOUNT (aka
 user-namespace-mountable) filesystems
Date: Sat, 27 Jul 2019 03:28:26 +0100
Message-ID: <20190727022826.GO1131@ZenIV.linux.org.uk>
References: <20190726115956.ifj5j4apn3tmwk64@brauner.io>
 <CAHk-=wgK254RkZg9oAv+Wt4V9zqYJMm3msTofvTUfA9dJw6piQ@mail.gmail.com>
 <20190726232220.GM1131@ZenIV.linux.org.uk>
 <878sskqp7p.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <878sskqp7p.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Christian Brauner <christian@brauner.io>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 26, 2019 at 07:46:18PM -0500, Eric W. Biederman wrote:

> If someone had bothered to actually look at how I was proposing to clean
> things up before the new mount api we would already have that.  Sigh.
> 
> You should be able to get away with something like this which moves the
> checks earlier and makes things clearer.  My old patch against the pre
> new mount api code.

Check your instances of ->permission(); AFAICS in all cases it's (in
current terms)
	return ns_capable(fc->user_ns, CAP_SYS_ADMIN) ? 0 : -EPERM;

In principle I like killing FS_USERNS_MOUNT flag, but when a method
is always either NULL or exact same function...
