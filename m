From: Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH for 5.4 0/3] Restartable Sequences Fixes
Date: Wed, 11 Dec 2019 08:47:12 -0700
Message-ID: <b67930c1-c8e0-124f-9a88-6ecace27317c@linuxfoundation.org>
References: <20190917182959.16333-1-mathieu.desnoyers@efficios.com>
 <211848436.2172.1576078102568.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <211848436.2172.1576078102568.JavaMail.zimbra@efficios.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, paulmck <paulmck@linux.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>, linux-api <linux-api@vger.kernel.org>, stable <stable@vger.kernel.org>, Shuah Khan <skhan@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

On 12/11/19 8:28 AM, Mathieu Desnoyers wrote:
> Hi Thomas,
> 
> I thought those rseq fixes posted in September were in the -tip tree, but it
> seems that they never made it to mainline.
> 
> Now Shuah Khan noticed the issue with gettid() compatibility with glibc
> 2.30+. This series contained that fix.
> 
> Should I re-post it, or is this series on track to get into mainline
> at some point ?
> 

It will be great this can make it into 5.5-rc2 or so.

thanks,
-- Shuah
