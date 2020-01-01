From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Date: Wed, 1 Jan 2020 23:40:09 +0000
Message-ID: <20200101234009.GB8904@ZenIV.linux.org.uk>
References: <20191230052036.8765-1-cyphar@cyphar.com>
 <20191230054413.GX4203@ZenIV.linux.org.uk>
 <20191230054913.c5avdjqbygtur2l7@yavin.dot.cyphar.com>
 <20191230072959.62kcojxpthhdwmfa@yavin.dot.cyphar.com>
 <20200101004324.GA11269@ZenIV.linux.org.uk>
 <20200101005446.GH4203@ZenIV.linux.org.uk>
 <20200101030815.GA17593@ZenIV.linux.org.uk>
 <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>, Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 02, 2020 at 01:44:07AM +1100, Aleksa Sarai wrote:

> Thanks, this fixes the issue for me (and also fixes another reproducer I
> found -- mounting a symlink on top of itself then trying to umount it).
> 
> Reported-by: Aleksa Sarai <cyphar@cyphar.com>
> Tested-by: Aleksa Sarai <cyphar@cyphar.com>

Pushed into #fixes.

> As for the original topic of bind-mounting symlinks -- given this is a
> supported feature, would you be okay with me sending an updated
> O_EMPTYPATH series?

Post it on fsdevel; I'll need to reread it anyway to say anything useful...
