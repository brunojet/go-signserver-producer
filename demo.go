package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
)

type Post struct {
	AccessToken string `json:"access_token"`
	ExpiresIn   int    `json:"expires_in"`
	TokenType   string `json:"token_type"`
}

func cognitoTest() {
	secret := "194o9n7bnuo7ukp1jr159e79mktm618osl0282bgjshjmc9hr77r"
	posturl := "https://us-east-1w3hyiscus.auth.us-east-1.amazoncognito.com/oauth2/token"

	body := []byte(fmt.Sprintf("grant_type=client_credentials&client_id=6qsvrm2avihg8h5m4181lspui6&client_secret=%s&scope=default-m2m-resource-server-msuovs/read", secret))

	r, err := http.NewRequest("POST", posturl, bytes.NewBuffer(body))
	if err != nil {
		panic(err)
	}

	r.Header.Add("Content-Type", "application/x-www-form-urlencoded")

	client := &http.Client{}
	res, err := client.Do(r)
	if err != nil {
		panic(err)
	}

	defer res.Body.Close()

	post := &Post{}
	derr := json.NewDecoder(res.Body).Decode(post)
	if derr != nil {
		panic(derr)
	}

	fmt.Println("AccessToken:", post.AccessToken)
	fmt.Println("ExpiresIn:", post.ExpiresIn)
	fmt.Println("TokenType:", post.TokenType)
}
