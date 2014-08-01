From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 2/5] raid: Require designated initialization of structures
Date: Thu, 31 Jul 2014 18:30:30 -0700
Message-ID: <20140801013030.GA20935@thin>
References: <3130b0553b15518e3bef6d14c80280beed0f5ff9.1406850006.git.josh@joshtriplett.org>
 <1d468224409ef2bf46874f817d19389ac5d1b26d.1406850006.git.josh@joshtriplett.org>
 <20140801111055.59419950@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kbuild-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140801111055.59419950@notabene.brown>
Sender: linux-kbuild-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: akpm@linux-foundation.org, "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christopher Li <sparse@chrisli.org>, Ingo Molnar <mingo@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Michal Marek <mmarek@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-sparse@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Aug 01, 2014 at 11:10:55AM +1000, NeilBrown wrote:
> On Thu, 31 Jul 2014 16:47:35 -0700 Josh Triplett <josh@joshtriplett.org>
> wrote:
> 
> > Mark raid6_calls and other structures containing function pointers with
> > __designated_init.  Fix implementations in lib/raid6/ to use designated
> > initializers; this also simplifies those initializers using the default
> > initialization of fields to 0.
> > 
> > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> 
> Looks like an excellent idea!
> Feel free to forward this upstream on my behalf, or remind me once the first
> patch is in -next, and I'll take this one myself - whichever you prefer.
> 
>  Acked-by: NeilBrown <neilb@suse.de>

Thanks!  Ideally, I'd like to see the whole series go in through one
tree, which is why I CCed Andrew.  I can easily produce several dozen
more patches like these, but I just included enough examples to motivate
patch 1, and I can send more in any order once that one goes in.

- Josh Triplett
