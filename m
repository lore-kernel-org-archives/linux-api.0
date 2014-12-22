From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH] selftests/exec: Use %zu to format size_t
Date: Mon, 22 Dec 2014 11:14:06 -0700
Message-ID: <54985F6E.2010205@osg.samsung.com>
References: <1419159496-11558-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1419159496-11558-1-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 12/21/2014 03:58 AM, Geert Uytterhoeven wrote:
> On 32-bit:
> 
> execveat.c: In function 'check_execveat_pathmax':
> execveat.c:183: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'size_t'
> execveat.c:187: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'
> 
> Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
> ---
>  tools/testing/selftests/exec/execveat.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/exec/execveat.c b/tools/testing/selftests/exec/execveat.c
> index 33a5c06d95caa038..d273624c93a64254 100644
> --- a/tools/testing/selftests/exec/execveat.c
> +++ b/tools/testing/selftests/exec/execveat.c
> @@ -179,11 +179,11 @@ static int check_execveat_pathmax(int dot_dfd, const char *src, int is_script)
>  	 */
>  	fd = open(longpath, O_RDONLY);
>  	if (fd > 0) {
> -		printf("Invoke copy of '%s' via filename of length %lu:\n",
> +		printf("Invoke copy of '%s' via filename of length %zu:\n",
>  			src, strlen(longpath));
>  		fail += check_execveat(fd, "", AT_EMPTY_PATH);
>  	} else {
> -		printf("Failed to open length %lu filename, errno=%d (%s)\n",
> +		printf("Failed to open length %zu filename, errno=%d (%s)\n",
>  			strlen(longpath), errno, strerror(errno));
>  		fail++;
>  	}
> 


Applied to kernel/git/shuah/linux-kselftest.git fixes
for 3.19-rc2

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
