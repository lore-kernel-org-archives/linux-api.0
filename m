From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] headers_check: don't warn about kexec.h
Date: Tue, 13 Jan 2015 22:05:11 +0100
Message-ID: <1421183111.15397.34.camel@x220>
References: <12825174.7oxZXDxNhV@wuerfel> <1421169212.15397.22.camel@x220>
	 <2363197.VbAKlSiQLX@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <2363197.VbAKlSiQLX@wuerfel>
Sender: linux-kbuild-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maximilian Attems <max@stro.at>, Geoff Levand <geoff@infradead.org>, Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org
List-Id: linux-api@vger.kernel.org

[Dragging Andrew, Linus, and Maximilian into this thread.]

On Tue, 2015-01-13 at 21:27 +0100, Arnd Bergmann wrote:
> On Tuesday 13 January 2015 18:13:32 Paul Bolle wrote:
> > The last time that Geoff has been trying to get that patch applied
> > should be
> > http://lkml.kernel.org/r/b0702fc4186db21820d686e89afd6480560823db.1415837218.git.geoff@infradead.org> 
> > I'd rather see that go in.
> 
> Fine with me as well. As long as we can find someone to take one of 
> the patches, I'm happy.

Since Geoff's patch (and my preceding, identical patch) basically is a
partial revert of commit 29a5c67e7a78 ("kexec: export kexec.h to user
space") that should probably be done by either Andrew or Linus. 

(This short thread starts at
http://lkml.kernel.org/r/12825174.7oxZXDxNhV@wuerfel .)


Paul Bolle

