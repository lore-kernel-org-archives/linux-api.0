From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCHv2] selftests/exec: allow shell return code of 126
Date: Tue, 06 Jan 2015 13:02:16 -0700
Message-ID: <54AC3F48.5010803@osg.samsung.com>
References: <1420532636-7317-1-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1420532636-7317-1-git-send-email-drysdale@google.com>
Sender: linux-m68k-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Andrew Morton <akpm@linux-foundation.org>, linux-m68k@lists.linux-m68k.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 01/06/2015 01:23 AM, David Drysdale wrote:
> When the shell fails to invoke a script because its path name
> is too long (ENAMETOOLONG), most shells return 127 to indicate
> command not found.  However, some systems report 126 (which POSIX
> suggests should indicate a non-executable file) for this case,
> so allow that too.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: David Drysdale <drysdale@google.com>
> Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  tools/testing/selftests/exec/execveat.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)

Thanks. Applied to kernel/git/shuah/linux-kselftest fixes branch

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
