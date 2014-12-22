From: David Drysdale <dmd@lurklurk.org>
Subject: Re: [PATCH selftest fails!] m68k: Wire up execveat
Date: Mon, 22 Dec 2014 17:54:47 -0500
Message-ID: <5498A137.6020707@lurklurk.org>
References: <alpine.DEB.2.10.1412211159410.7624@ayla.of.borg>	<874msp3w7j.fsf@igel.home> <CAHse=S-KzC5y8eC_ZFrbUJo0Ub5Qv8WeeXHdY1-F=HckAX=L=A@mail.gmail.com>
Reply-To: David Drysdale <drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <CAHse=S-KzC5y8eC_ZFrbUJo0Ub5Qv8WeeXHdY1-F=HckAX=L=A@mail.gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>, schwab@linux-m68k.org, geert@linux-m68k.org
Cc: shuahkh@osg.samsung.com, akpm@linux-foundation.org, linux-api@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

[Re-send from a different email address because I apparently can't send 
plaintext from gMail on my phone.]

On 21 Dec 2014 09:37, "Andreas Schwab" <schwab@linux-m68k.org> wrote:
 >
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>
>  > Check success of execveat(5,
> 'xxxxxxxxxxxxxxxxxxxx...yyyyyyyyyyyyyyyyyyyy', 0)... [FAIL] (child 792
> exited with 126 not 127)
>
> POSIX says
> (http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_08_02):
>
>      If a command is not found, the exit status shall be 127. If the
>      command name is found, but it is not an executable utility, the exit
>      status shall be 126.
>
 > Andreas.
 >

That sounds like a bit of a grey area -- is ENAMETOOLONG nearer to 
ENOENT or EACCES?   Maybe it's best to make the test allow either (given 
that it's not a test of shell behaviour).

I can update the test to do that, but it probably won't be until the new 
year I'm afraid.

David
