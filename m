From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Subject: Re: kdbus: add selftests
Date: Fri, 14 Nov 2014 09:56:37 +0100
Message-ID: <5465C3C5.2040606@zonque.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>	 <1414620056-6675-13-git-send-email-gregkh@linuxfoundation.org> <1415936530.26378.2.camel@concordia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415936530.26378.2.camel@concordia>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/14/2014 04:42 AM, Michael Ellerman wrote:
> On Wed, 2014-10-29 at 15:00 -0700, Greg Kroah-Hartman wrote:
>> From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
>>
>> This patch adds a quite extensive test suite for kdbus that checks
>> the most important code pathes in the driver. The idea is to extend
>> the test suite over time.
>>
>> Also, this code can serve as an example implementation to show how to
>> use the kernel API from userspace.
> 
> Great to see selftests included.
> 
> I needed this to get them building:

Thanks a lot for testing! I've added your hunks to the patch set now.


Daniel
