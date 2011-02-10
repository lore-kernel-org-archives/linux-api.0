From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
Date: Thu, 10 Feb 2011 19:12:21 +0100
Message-ID: <20110210181221.GA19413@win.tue.nl>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com> <201101251529.24779.arnd@arndb.de> <20110125174515.C1DC2183C19@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-ports-return-1835-gclgp-libc-ports=m.gmane.org@sourceware.org>
Content-Disposition: inline
In-Reply-To: <20110125174515.C1DC2183C19@magilla.sf.frob.com>
List-Unsubscribe: <mailto:libc-ports-unsubscribe-gclgp-libc-ports=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-ports-subscribe@sourceware.org>
List-Post: <mailto:libc-ports@sourceware.org>
List-Help: <mailto:libc-ports-help@sourceware.org>, <http://sourceware.org/lists.html#faqs>
Sender: libc-ports-owner@sourceware.org
To: Roland McGrath <roland@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linasvepstas@gmail.com, Chris Metcalf <cmetcalf@tilera.com>, GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org, libc-ports@sourceware.org, linux-api@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 25, 2011 at 09:45:15AM -0800, Roland McGrath wrote:

> the empty string has never been a valid relative pathname.

Hmm. I definitely recall otherwise.

The old Unix definition is that the empty string stands for "."
so that 'ls ""' means the same as 'ls .'
and 'ls /tmp/""' the same as 'ls /tmp/.'.

Let me try.

On a recent Linux system:

% ls -l ""
ls: cannot access : No such file or directory

On an old Unix system:

# ls -l ""
drwxr-xr-x  2 bin      1040 Jan  1  1970 bin
drwxr-xr-x  2 bin       352 Jan  1  1970 dev
drwxr-xr-x  2 bin       304 Aug 20 12:39 etc
...

Andries
