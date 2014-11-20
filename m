From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH] kselftest: Move the docs to the Documentation dir
Date: Thu, 20 Nov 2014 06:56:53 -0700
Message-ID: <546DF325.6060507@osg.samsung.com>
References: <546D32D0.9090206@sonymobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <546D32D0.9090206@sonymobile.com>
Sender: linux-doc-owner@vger.kernel.org
To: Tim Bird <tim.bird@sonymobile.com>, linux-api@vger.kernel.org, corbet@lwn.net
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>, Shuah Khan <shuahkh@osg.samsung.com>, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/19/2014 05:16 PM, Tim Bird wrote:
> 
> Also, adjust the formatting a bit, and expand the section about using
> TARGETS= on the make command line.
> 
> Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
> ---
>  Documentation/kselftest.txt        | 69 ++++++++++++++++++++++++++++++++++++++
>  tools/testing/selftests/README.txt | 61 ---------------------------------
>  2 files changed, 69 insertions(+), 61 deletions(-)
>  create mode 100644 Documentation/kselftest.txt
>  delete mode 100644 tools/testing/selftests/README.txt
> 
> diff --git a/Documentation/kselftest.txt b/Documentation/kselftest.txt
> new file mode 100644
> index 0000000..a87d840
> --- /dev/null
> +++ b/Documentation/kselftest.txt
>

Tim,

Thanks for doing this. Looks good to me. I think you missed
Documentation maintainer. Adding linux-doc and Jon Corbet to
the thread with my ack to take this through Documentation tree.

Acked-by: shuahkh@osg.samsung.com

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
