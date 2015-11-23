From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH V2 0/3] Clean up and enable two testcases in kselftest
Date: Mon, 23 Nov 2015 13:33:40 -0700
Message-ID: <56537824.5030703@osg.samsung.com>
References: <1447770943-10059-1-git-send-email-bamvor.zhangjian@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447770943-10059-1-git-send-email-bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/17/2015 07:35 AM, Bamvor Jian Zhang wrote:
> These patches try to enable two testcases (capabilities and ipc) and
> make them build successful in cross compiling environment.
> 
> Clean up the Makefile of capabilities according to the usage in
> kselftest.
> 
> Changes since v1
> 1.  Update Makefile of capabilities according to Michael's suggestion.
>     reference commit message for details.
> 
> Bamvor Jian Zhang (3):
>   selftests/capabilities: clean up for Makefile
>   selftests/capabilities: actually test it
>   selftest/ipc: actually test it
> 
>  tools/testing/selftests/Makefile              |  2 ++
>  tools/testing/selftests/capabilities/Makefile | 21 +++++++++------------
>  2 files changed, 11 insertions(+), 12 deletions(-)
> 

Thanks. These 3 patches are now in linux-kselftest next
for 4.5-rc1

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
