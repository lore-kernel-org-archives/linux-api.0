From: Kevin Easton <kevin@guarana.org>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
Date: Wed, 17 Sep 2014 21:36:46 +1000
Message-ID: <20140917113646.GA14001@chicago.guarana.org>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1410912351-31273-1-git-send-email-rlarocque@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Larocque <rlarocque@google.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, luto@amacapital.net, filbranden@google.com, md@google.com, gthelen@google.com, x86@kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Sep 16, 2014 at 05:05:51PM -0700, Richard Larocque wrote:
> +	case PR_SET_VDSO:
> +		if (arg2 == PR_VDSO_ENABLE)
> +			me->signal->disable_vdso = 0;
> +		else if (arg2 == PR_VDSO_DISABLE)
> +			me->signal->disable_vdso = 1;
> +		else
> +			return -EINVAL;
> +		break;
> +	case PR_GET_VDSO:
> +		if (!me->signal->disable_vdso)
> +			error = put_user(PR_VDSO_ENABLE, (int __user *)arg2);
> +		else
> +			error = put_user(PR_VDSO_DISABLE, (int __user *)arg2);
> +		break;

Perhaps both of those should do

if (arg3 || arg4 || arg5)
	return -EINVAL;

    - Kevin
