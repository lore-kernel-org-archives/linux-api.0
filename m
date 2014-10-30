From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Thu, 30 Oct 2014 08:12:01 +0100
Message-ID: <5451E4C1.3000704@zonque.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>	<20141029221505.GA7812@kroah.com> <87egtqurrp.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87egtqurrp.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/30/2014 05:04 AM, Eric W. Biederman wrote:
> For what it is worth these patches are also poorly split up.  Every
> patch I looked at in detail had functions that were being introduced
> that did not have callers.

Yes, we wanted to keep the reply threading cleaner and the individual
patches short. With a patch set that avoids introducing functions
without callers, each patch would have grown substantially. But I know
that's unusual to do it that way.

> That poor split up of the patches makes it difficult to see how
> the functionality that is being introduced is being used.

Ok, I see. For now, I think it's probably easiest to pull the patches
from here, and then look at the resulting files directly:


https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-misc.git/log/?h=kdbus

Other than that, please give us some time to respond to your longer
reply. Thanks for taking the time to write this up!


Daniel
