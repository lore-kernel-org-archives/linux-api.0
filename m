From: David Sterba <dsterba@suse.cz>
Subject: Re: [GIT PULL] pipe: Notification queue preparation
Date: Thu, 5 Dec 2019 19:18:09 +0100
Message-ID: <20191205181809.GX2734@suse.cz>
References: <20191205172127.GW2734@suse.cz>
 <20191205125826.GK2734@twin.jikos.cz>
 <31452.1574721589@warthog.procyon.org.uk>
 <1593.1575554217@warthog.procyon.org.uk>
 <21493.1575566720@warthog.procyon.org.uk>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <21493.1575566720@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 05, 2019 at 05:25:20PM +0000, David Howells wrote:
> I've just posted a couple of patches - can you check to see if they fix your
> problem?
> 
> https://lore.kernel.org/linux-fsdevel/157556649610.20869.8537079649495343567.stgit@warthog.procyon.org.uk/T/#t

Not fixed, the test still hangs with the same call stack.
