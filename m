Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF9D43932A;
	Mon, 20 Jul 2026 21:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784583830; cv=none; b=ilOL/fT75AXTFzChEzq9wUWJ6Oms/fBJpSrnE2rMKZFYQVzkomxX1Iwva4zpmEaGBw9zU57IkrHZo8hfwyuPCU0YG+UjHvRnnB5QZ8aU8rgs3wJcCWRr0Zh4iB3yfwjHkRP2b2pOFStEu6dLkEqqMqb3OTVz1pKtZaSFUnXC50E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784583830; c=relaxed/simple;
	bh=tXyWYB6lpfIn7RobsEycD1pGnBeQbVSsafA7QT5htxk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZtHvN7WouHC6QekGGjzk/rL0hu6BYotSoo6R/zkWQC0+r9hgQP1DxN9Brd2ZvpEXtOXW/n7wk3jaWiPCJwvuxOoHXkUHkDFPa1H9xdzE7I1zQeBqeAHU9ZrDSAYVEaQ9juWHDMUYgrVDrD79GSk9q6XqQFtMRqLGxa5Bzx6CUk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F5D1F000E9;
	Mon, 20 Jul 2026 21:43:49 +0000 (UTC)
Received: by venus (Postfix, from userid 1000)
	id E6E82180DDB; Mon, 20 Jul 2026 23:43:45 +0200 (CEST)
From: Sebastian Reichel <sebastian.reichel@collabora.com>
To: Sebastian Reichel <sre@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Boris Shtrasman <borissh1983@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-api@vger.kernel.org
In-Reply-To: <20260624135718.286771-1-borissh1983@gmail.com>
References: <20260624135718.286771-1-borissh1983@gmail.com>
Subject: Re: PATCH v2 0/2] Power: supply: Add PbAc, NiZn, RAM, and ZnAr
 support
Message-Id: <178458382593.311390.15118847945371096549.b4-ty@collabora.com>
Date: Mon, 20 Jul 2026 23:43:45 +0200
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 24 Jun 2026 16:57:16 +0300, Boris Shtrasman wrote:
> These series adds support for PbAc, NiZn, RAM, and ZnAr chemistries as
> defined in the Smart Battery Data Specification v1.1 (Section 5.1.30
> DeviceChemistry).
> 
> Currently, the sbs-battery driver only handles LION, LiP, NiCd and NiMH.
> The Smart Battery specification defines 8 possible values:
>  - Lead Acid (PbAc)
>  - Lithium Ion (LION)
>  - Nickel Cadmium (NiCd)
>  - Nickel Metal Hydride (NiMH)
>  - Nickel Zinc (NiZn)
>  - Rechargeable Alkaline-Manganese (RAM)
>  - Zinc Air (ZnAr)
>  - Lithium Polymer (LiP)
> 
> [...]

Applied, thanks!

[1/2] power: supply: Add PbAc, NiZn, RAM, and ZnAr support
      commit: defb072f411c630337946f3babf1bf9b38b23a84
[2/2] power: supply: sbs-battery: Add PbAc, NiZn, RAM, and ZnAr support
      commit: 751253c3c3a40c43de8014a9d81e9e9a9f7b1039

Best regards,
-- 
Sebastian Reichel <sebastian.reichel@collabora.com>

