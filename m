From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] selftest: change cpu on-off-test.sh name to be unique
Date: Wed, 1 Apr 2015 14:04:17 +0200
Message-ID: <20150401120417.GB3218@kroah.com>
References: <1427847031-9286-1-git-send-email-shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1427847031-9286-1-git-send-email-shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Mar 31, 2015 at 06:10:31PM -0600, Shuah Khan wrote:
> cpu and memory hotplug scripts use the same name. Change
> cpu on-off-test.sh to cpu-on-off-test.sh.
> 
> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> ---
>  tools/testing/selftests/cpu-hotplug/Makefile       |   4 +-
>  .../selftests/cpu-hotplug/cpu-on-off-test.sh       | 269 +++++++++++++++++++++
>  tools/testing/selftests/cpu-hotplug/on-off-test.sh | 269 ---------------------
>  3 files changed, 271 insertions(+), 271 deletions(-)
>  create mode 100755 tools/testing/selftests/cpu-hotplug/cpu-on-off-test.sh
>  delete mode 100755 tools/testing/selftests/cpu-hotplug/on-off-test.sh

Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
