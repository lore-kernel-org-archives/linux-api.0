From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Date: Mon, 30 Dec 2019 05:44:13 +0000
Message-ID: <20191230054413.GX4203@ZenIV.linux.org.uk>
References: <20191230052036.8765-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191230052036.8765-1-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>, Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Dec 30, 2019 at 04:20:35PM +1100, Aleksa Sarai wrote:

> A reasonably detailed explanation of the issues is provided in the patch
> itself, but the full traces produced by both the oopses and deadlocks is
> included below (it makes little sense to include them in the commit since we
> are disabling this feature, not directly fixing the bugs themselves).
> 
> I've posted this as an RFC on whether this feature should be allowed at
> all (and if anyone knows of legitimate uses for it), or if we should
> work on fixing these other kernel bugs that it exposes.

Umm...  Are all of those traces
	a) reproducible on mainline and
	b) reproducible as the first oopsen?

As it is, quite a few might be secondary results of earlier memory
corruption...
