From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v9 05/10] namei: O_BENEATH-style path resolution flags
Date: Sat, 13 Jul 2019 03:41:53 +0100
Message-ID: <20190713024153.GA3817@ZenIV.linux.org.uk>
References: <20190706145737.5299-1-cyphar@cyphar.com>
 <20190706145737.5299-6-cyphar@cyphar.com>
 <20190712043341.GI17978@ZenIV.linux.org.uk>
 <20190712105745.nruaftgeat6irhzr@yavin>
 <20190712123924.GK17978@ZenIV.linux.org.uk>
 <20190712125552.GL17978@ZenIV.linux.org.uk>
 <20190712132553.GN17978@ZenIV.linux.org.uk>
 <20190712150026.GO17978@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190712150026.GO17978@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Christian Brauner <christian@brauner.io>, David Drysdale <drysdale@google.com>, Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, containers@lists.linux-foundation.org, linux-alpha@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 12, 2019 at 04:00:26PM +0100, Al Viro wrote:
> On Fri, Jul 12, 2019 at 02:25:53PM +0100, Al Viro wrote:
> 
> > 	if (flags & LOOKUP_BENEATH) {
> > 		nd->root = nd->path;
> > 		if (!(flags & LOOKUP_RCU))
> > 			path_get(&nd->root);
> > 		else
> > 			nd->root_seq = nd->seq;
> 
> BTW, this assignment is needed for LOOKUP_RCU case.  Without it
> you are pretty much guaranteed that lazy pathwalk will fail,
> when it comes to complete_walk().
> 
> Speaking of which, what would happen if LOOKUP_ROOT/LOOKUP_BENEATH
> combination would someday get passed?

I don't understand what's going on with ->r_seq in there - your
call of path_is_under() is after having (re-)sampled rename_lock,
but if that was the only .. in there, who's going to recheck
the value?  For that matter, what's to guarantee that the thing
won't get moved just as you are returning from handle_dots()?

IOW, what does LOOKUP_IN_ROOT guarantee for caller (openat2())?
