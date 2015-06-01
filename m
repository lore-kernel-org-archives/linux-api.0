From: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Subject: Re: [PATCH 25/98] sctp.h: use __u8 and __u32 from linux/types.h
Date: Mon, 1 Jun 2015 09:40:00 -0400
Message-ID: <20150601134000.GA21592@hmsreliant.think-freely.org>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
 <1433000370-19509-26-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433000370-19509-26-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlad Yasevich <vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, May 30, 2015 at 05:38:17PM +0200, Mikko Rapeli wrote:
> Fixes userspace compilation errors like:
>=20
> linux/sctp.h:652:2: error: unknown type name =E2=80=98uint32_t=E2=80=99
>=20
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> ---
>  include/uapi/linux/sctp.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> index ce70fe6..dd0a9c2 100644
> --- a/include/uapi/linux/sctp.h
> +++ b/include/uapi/linux/sctp.h
> @@ -718,13 +718,13 @@ struct sctp_authkeyid {
>   */
>  struct sctp_sack_info {
>  	sctp_assoc_t	sack_assoc_id;
> -	uint32_t	sack_delay;
> -	uint32_t	sack_freq;
> +	__u32	sack_delay;
> +	__u32	sack_freq;
>  };
> =20
>  struct sctp_assoc_value {
>      sctp_assoc_t            assoc_id;
> -    uint32_t                assoc_value;
> +    __u32                assoc_value;
>  };
> =20
>  /*
> @@ -794,7 +794,7 @@ struct sctp_status {
>  struct sctp_authchunks {
>  	sctp_assoc_t	gauth_assoc_id;
>  	__u32		gauth_number_of_chunks;
> -	uint8_t		gauth_chunks[];
> +	__u8		gauth_chunks[];
>  };
> =20
>  /* The broken spelling has been released already in lksctp-tools hea=
der,
> --=20
> 2.1.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
Acked-by: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
