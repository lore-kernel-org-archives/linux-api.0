From: Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: [PATCH selftest fails!] m68k: Wire up execveat
Date: Sun, 21 Dec 2014 15:37:36 +0100
Message-ID: <874msp3w7j.fsf@igel.home>
References: <alpine.DEB.2.10.1412211159410.7624@ayla.of.borg>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1412211159410.7624@ayla.of.borg> (Geert
	Uytterhoeven's message of "Sun, 21 Dec 2014 12:02:11 +0100 (CET)")
Sender: linux-m68k-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Drysdale <drysdale@google.com>, Shuah Khan <shuahkh@osg.samsung.com>, Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org, Linux/m68k <linux-m68k@lists.linux-m68k.org>, Linux Kernel Development <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> Check success of execveat(5, 'xxxxxxxxxxxxxxxxxxxx...yyyyyyyyyyyyyyyyyyyy', 0)... [FAIL] (child 792 exited with 126 not 127)

POSIX says (http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_08_02):

    If a command is not found, the exit status shall be 127. If the
    command name is found, but it is not an executable utility, the exit
    status shall be 126.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
