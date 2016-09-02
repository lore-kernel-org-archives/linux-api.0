From: Andrew Shadura <andrew.shadura-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Subject: Re: tools-powerpc: Return false instead of -1
Date: Fri, 2 Sep 2016 11:54:13 +0200
Message-ID: <dbaeea41-e3a6-0469-1e3a-bfda59eb4c46@collabora.co.uk>
References: <1442487801-22661-1-git-send-email-peter.senna@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442487801-22661-1-git-send-email-peter.senna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Senna Tschudin <peter.senna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, sam.bobroff-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 17/09/15 13:03, Peter Senna Tschudin wrote:
> Returning a negative value for a boolean function seem to have the
> undesired effect of returning true. require_paranoia_below() is a
> boolean function, but the variable used to store the return value is an
> integer, receiving -1 or 0. This patch convert rc to bool, replace -1
> by false, and 0 by true.

The issue still seems to be not fixed.

-- 
Cheers,
  Andrew
