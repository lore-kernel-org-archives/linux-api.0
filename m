Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D1C1D435F;
	Sun, 15 Mar 2026 01:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773537597; cv=none; b=RMkwhjm0ubSuBYYJDDKeMza3I+Uxz1ad77rJqbM4V3y6nLQLVcV5KySJ99yP84jBntquRWGu4WGkn8CRkhpInOCanQGMRpq0x6mmfEybwNCVFTlNl6HkVI5JUIQ/zhNGr6bOTSj8zdpp24MFbFpPqK7gPqHUj5VLTgGK0VpZLzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773537597; c=relaxed/simple;
	bh=h0DG2xaeR8KdeW9n8FazcNV9h5yIblTYtboeu3f9tlM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gQlugDw8sSK0mUD8emiEr7H7vUrCqjiqaRJCHQ+zFB9QVkL3eQ8XIYHFpQx31BbQGLG7CP8LZKIeT+EL33vfW5Yy6xd4+P+RvLwasg5QrXuwDpOvRSRiB4haBXzWTQLGaiCO1SnVWyLvj+Y+OP9DBUOM3WqdN62BVk+Pxn02H1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZfJmdOBo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZfJmdOBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA66C116C6;
	Sun, 15 Mar 2026 01:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773537596;
	bh=h0DG2xaeR8KdeW9n8FazcNV9h5yIblTYtboeu3f9tlM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZfJmdOBoJAmvtPI7jXoLWF8KeSOFXjuAnu64PxZdyM2ezxmUQq+hen21t42T72mcy
	 ovIkIrHtiE7TkJ7TBdMIFIlLjhrOkk86aKhn+P+5ZdukxSgx1W0OmbWr+SITCf0t+k
	 Gmbyav+GO4ERrXUXeNsvKOLz3sSawKdRIspI9djl5VJ3Mj8CH9dJrWYW+SeldsDskf
	 eXrIXnHzd4PuM8swOogh5J9u3ZuuYkSDwfDp93R8xKSA8iJoDcYiW5LB9CyeHdDlYx
	 Wa1+NsuGbtF5DjyU9GaEU5ofdQAfkOOQw0V4s5DvD/N3dvg/too+j8WHNls0lP7Mg/
	 e3J6fhaNfdwDw==
Date: Sat, 14 Mar 2026 18:19:54 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: atwellwea@gmail.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
 edumazet@google.com, ncardwell@google.com, linux-kernel@vger.kernel.org,
 linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 mptcp@lists.linux.dev, dsahern@kernel.org, horms@kernel.org,
 kuniyu@google.com, andrew+netdev@lunn.ch, willemdebruijn.kernel@gmail.com,
 jasowang@redhat.com, skhan@linuxfoundation.org, corbet@lwn.net,
 matttbe@kernel.org, martineau@kernel.org, geliang@kernel.org,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 0x7f454c46@gmail.com
Subject: Re: [PATCH net-next v2 00/14] tcp: preserve receive-window
 accounting across ratio drift
Message-ID: <20260314181954.390bf6bc@kernel.org>
In-Reply-To: <20260314201348.1786972-1-atwellwea@gmail.com>
References: <20260314201348.1786972-1-atwellwea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 14 Mar 2026 14:13:34 -0600 atwellwea@gmail.com wrote:
> This series keeps sender-visible TCP receive-window accounting tied to the
> scaling basis that was in force when the window was advertised, even if
> later receive-side truesize inflation lowers scaling_ratio or the live
> receive window retracts below the largest right edge already exposed to the
> sender.

Please wait until at least Monday before reposting this.
LLM-pocalypse is hitting us hard
