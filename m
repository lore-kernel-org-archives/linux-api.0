From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Subject: Re: kdbus: add code for buses, domains and endpoints
Date: Fri, 31 Oct 2014 10:55:27 +0100
Message-ID: <54535C8F.30707@zonque.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org> <20141031013922.GG7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141031013922.GG7996-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

On 10/31/2014 02:39 AM, Al Viro wrote:
> On Wed, Oct 29, 2014 at 03:00:52PM -0700, Greg Kroah-Hartman wrote:
>> See Documentation/kdbus.txt for more details.
> 
> ... which has nothing whatsoever on object lifetime rules.

True. That document only describes the external API exposed by the
driver towards userspace.

> Could you
> folks please document that somewhere?  What pins what, what state
> transitions are possible, etc.

Hmm, I'll see whether I can write something up.

> BTW, the calling conventions for your foo_new() are annoying - instead of
> "return -E... or 0, storing the reference to new object in var parameter
> passed as the last argument", could you please just return ERR_PTR(-E...)
> on error, a pointer to new object on success and to hell with those
> struct foo **foo in the argument lists?

No problem at all. We'll change that around.


Thanks for your feedback, much appreciated!

Daniel
