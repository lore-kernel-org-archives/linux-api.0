From: Andreas Schwab <schwab@redhat.com>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
Date: Fri, 11 Feb 2011 10:11:39 +0100
Message-ID: <m34o8bq6k4.fsf@redhat.com>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com>	<201101251529.24779.arnd@arndb.de>	<20110125174515.C1DC2183C19@magilla.sf.frob.com>	<20110210181221.GA19413@win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-ports-return-1837-gclgp-libc-ports=m.gmane.org@sourceware.org>
In-Reply-To: <20110210181221.GA19413@win.tue.nl> (Andries Brouwer's message of	"Thu, 10 Feb 2011 19:12:21 +0100")
List-Unsubscribe: <mailto:libc-ports-unsubscribe-gclgp-libc-ports=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-ports-subscribe@sourceware.org>
List-Post: <mailto:libc-ports@sourceware.org>
List-Help: <mailto:libc-ports-help@sourceware.org>, <http://sourceware.org/lists.html#faqs>
Sender: libc-ports-owner@sourceware.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: Roland McGrath <roland@redhat.com>, Arnd Bergmann <arnd@arndb.de>, linasvepstas@gmail.com, Chris Metcalf <cmetcalf@tilera.com>, GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org, libc-ports@sourceware.org, linux-api@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>
List-Id: linux-api@vger.kernel.org

Andries Brouwer <aebr@win.tue.nl> writes:

> and 'ls /tmp/""' the same as 'ls /tmp/.'.

/tmp/"" is not an empty file name, and it is indistinguishable from /tmp/ .

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
