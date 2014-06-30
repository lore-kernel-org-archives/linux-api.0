From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
Date: Mon, 30 Jun 2014 13:40:40 -0700
Message-ID: <87mwcuw2pj.fsf@tassilo.jf.intel.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
	<1404124096-21445-2-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1404124096-21445-2-git-send-email-drysdale@google.com> (David
	Drysdale's message of "Mon, 30 Jun 2014 11:28:01 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

David Drysdale <drysdale@google.com> writes:

> Add a new O_BENEATH_ONLY flag for openat(2) which restricts the
> provided path, rejecting (with -EACCES) paths that are not beneath
> the provided dfd.  In particular, reject:
>  - paths that contain .. components
>  - paths that begin with /
>  - symlinks that have paths as above.

How about bind mounts?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
