From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH] selftests/exec: allow shell return code of 126
Date: Mon, 05 Jan 2015 12:03:39 -0700
Message-ID: <54AAE00B.1020809@osg.samsung.com>
References: <1420456786-5989-1-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1420456786-5989-1-git-send-email-drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Andreas Schwab <schwab-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-m68k-cunTk1MwBs8S/qaLPR03pWD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 01/05/2015 04:19 AM, David Drysdale wrote:
> When the shell fails to invoke a script because its path name
> is too long (ENAMETOOLONG), most shells return 127 to indicate
> command not found.  However, some systems report 126 (which POSIX
> suggests should indicate a non-executable file) for this case,
> so allow that too.
> 
> Reported-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
> Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  tools/testing/selftests/exec/execveat.c | 28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/exec/execveat.c b/tools/testing/selftests/exec/execveat.c
> index d273624c93a6..0d940c6e26bd 100644
> --- a/tools/testing/selftests/exec/execveat.c
> +++ b/tools/testing/selftests/exec/execveat.c
> @@ -62,7 +62,7 @@ static int _check_execveat_fail(int fd, const char *path, int flags,
>  }
>  
>  static int check_execveat_invoked_rc(int fd, const char *path, int flags,
> -				     int expected_rc)
> +				     int expected_rc, int expected_rc2)

This logic doesn't scale well if there other expected return
values to account for. Please think about a re-write to handle
multiple expected return codes.


>  {
>  	int status;
>  	int rc;
> @@ -99,9 +99,19 @@ static int check_execveat_invoked_rc(int fd, const char *path, int flags,
>  		return 1;
>  	}
>  	if (WEXITSTATUS(status) != expected_rc) {
> -		printf("[FAIL] (child %d exited with %d not %d)\n",
> -			child, WEXITSTATUS(status), expected_rc);
> -		return 1;
> +		if (expected_rc != expected_rc2) {

Please collapse expected_rc and expected_rc2 checks. You can rephrase
the error message to work for both cases.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
