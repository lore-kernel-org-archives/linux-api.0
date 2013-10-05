From: Manuel Reimer <Manuel.Spam-Xv0xCBoRcaZkYx7DZD8BGw@public.gmane.org>
Subject: adjtime vs. adjtimex
Date: Sat, 05 Oct 2013 21:43:38 +0200
Message-ID: <l2pq4d$2fv$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

I don't know if I'm on the right list. Please point me to a better list 
if I'm wrong.

What I want to do is to adjust time *once a day* only, but I would 
prefer to not let the system time jump.

So I have the choice between adjtime and adjtimex.

I would prefer adjtimex, as it enables "11 minute mode" for the hardware 
clock.

I tried to set an offset with adjtimex and set the clock to status 
"TIME_OK". My problem is, that this status seems to get lost as soon as 
my program exits.

If I use "adjtime", then my offset is stored but I can't set the clock 
to "TIME_OK", so I have to handle hwclock on my own.

Is it possible to use "adjtimex" in a "fire and forget" manner? Is it 
possible to set an offset and time status to "OK" and keep this status 
even if my process exits?

Thanks in advance.

Greetings,

Manuel
